CREATE TABLE serialize_test (
        id INTEGER,
        description VARCHAR,
        ewkt VARCHAR,
        serialized TEXT);
select sn_create_distributed_table('serialize_test', 'id', 'none');

INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        1, 'Circular String',
        'CIRCULARSTRING(-2 0,0 2,2 0,0 2,2 4)',
        '01080000000500000000000000000000C0000000000000000000000000000000000000000000000040000000000000004000000000000000000000000000000000000000000000004000000000000000400000000000001040');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        2, 'Circular String, SRID=4326',
        'SRID=4326;CIRCULARSTRING(-2 0,0 2,2 0,0 2,2 4)',
        '0108000020E61000000500000000000000000000C0000000000000000000000000000000000000000000000040000000000000004000000000000000000000000000000000000000000000004000000000000000400000000000001040');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        3, 'Circular String 3dz, SRID=4326',
        'SRID=4326;CIRCULARSTRING(-2 0 1,0 2 1,2 0 1,0 2 1,2 4 1)',
        '01080000A0E61000000500000000000000000000C00000000000000000000000000000F03F00000000000000000000000000000040000000000000F03F00000000000000400000000000000000000000000000F03F00000000000000000000000000000040000000000000F03F00000000000000400000000000001040000000000000F03F');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        4, 'Circular String 3dm, SRID=4326',
        'SRID=4326;CIRCULARSTRINGM(-2 0 1,0 2 1,2 0 1,0 2 1,2 4 1)',
        '0108000060E61000000500000000000000000000C00000000000000000000000000000F03F00000000000000000000000000000040000000000000F03F00000000000000400000000000000000000000000000F03F00000000000000000000000000000040000000000000F03F00000000000000400000000000001040000000000000F03F');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        5, 'Circular String 4d, SRID=4326',
        'SRID=4326;CIRCULARSTRING(-2 0 1 0,0 2 1 0,2 0 1 0,0 2 1 0,2 4 1 0)',
        '01080000E0E61000000500000000000000000000C00000000000000000000000000000F03F000000000000000000000000000000000000000000000040000000000000F03F000000000000000000000000000000400000000000000000000000000000F03F000000000000000000000000000000000000000000000040000000000000F03F000000000000000000000000000000400000000000001040000000000000F03F0000000000000000');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        6, 'Compound Curve',
        'COMPOUNDCURVE(CIRCULARSTRING(0 0,1 1,1 0),(1 0,0 1))',
        '01090000000200000001080000000300000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F0000000000000000010200000002000000000000000000F03F00000000000000000000000000000000000000000000F03F');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        7, 'Compound Curve, SRID=4326',
        'SRID=4326;COMPOUNDCURVE(CIRCULARSTRING(0 0,1 1,1 0),(1 0,0 1))',
        '0109000020E61000000200000001080000000300000000000000000000000000000000000000000000000000F03F000000000000F03F000000000000F03F0000000000000000010200000002000000000000000000F03F00000000000000000000000000000000000000000000F03F');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        8, 'Compound Curve 3dz, SRID=4326',
        'SRID=4326;COMPOUNDCURVE(CIRCULARSTRING(0 0 2,1 1 2,1 0 2),(1 0 2,0 1 2))',
        '01090000A0E610000002000000010800008003000000000000000000000000000000000000000000000000000040000000000000F03F000000000000F03F0000000000000040000000000000F03F00000000000000000000000000000040010200008002000000000000000000F03F000000000000000000000000000000400000000000000000000000000000F03F0000000000000040');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        9, 'Compound Curve 3dm, SRID=4326',
        'SRID=4326;COMPOUNDCURVEM(CIRCULARSTRINGM(0 0 2,1 1 2,1 0 2),(1 0 2,0 1 2))',
        '0109000060E610000002000000010800004003000000000000000000000000000000000000000000000000000040000000000000F03F000000000000F03F0000000000000040000000000000F03F00000000000000000000000000000040010200004002000000000000000000F03F000000000000000000000000000000400000000000000000000000000000F03F0000000000000040');
INSERT INTO serialize_test (
        id, description, ewkt, serialized
      ) VALUES (
        10, 'Compound Curve 4d, SRID=4326',
        'SRID=4326;COMPOUNDCURVE(CIRCULARSTRING(0 0 2 5,1 1 2 5,1 0 2 5),(1 0 2 5,0 1 2 2))',
        '01090000E0E61000000200000001080000C0030000000000000000000000000000000000000000000000000000400000000000001440000000000000F03F000000000000F03F00000000000000400000000000001440000000000000F03F00000000000000000000000000000040000000000000144001020000C002000000000000000000F03F0000000000000000000000000000004000000000000014400000000000000000000000000000F03F00000000000000400000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        11, 'Curve Polygon',
        'CURVEPOLYGON(CIRCULARSTRING(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0),(-1 0,0 0.5,1 0,0 1,-1 0))',
        '010A0000000200000001080000000700000000000000000000C00000000000000000000000000000F0BF000000000000F0BF00000000000000000000000000000000000000000000F03F000000000000F0BF000000000000004000000000000000000000000000000000000000000000004000000000000000C00000000000000000010200000005000000000000000000F0BF00000000000000000000000000000000000000000000E03F000000000000F03F00000000000000000000000000000000000000000000F03F000000000000F0BF0000000000000000');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        12, 'Curve Polygon, SRID=4326',
        'SRID=4326;CURVEPOLYGON(CIRCULARSTRING(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0),(-1 0,0 0.5,1 0,0 1,-1 0))',
        '010A000020E61000000200000001080000000700000000000000000000C00000000000000000000000000000F0BF000000000000F0BF00000000000000000000000000000000000000000000F03F000000000000F0BF000000000000004000000000000000000000000000000000000000000000004000000000000000C00000000000000000010200000005000000000000000000F0BF00000000000000000000000000000000000000000000E03F000000000000F03F00000000000000000000000000000000000000000000F03F000000000000F0BF0000000000000000');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        13, 'Curve Polygon 3dz, SRID=4326',
        'SRID=4326;CURVEPOLYGON(CIRCULARSTRING(-2 0 0,-1 -1 1,0 0 2,1 -1 3,2 0 4,0 2 2,-2 0 0),(-1 0 1,0 0.5 2,1 0 3,0 1 3,-1 0 1))',
        '010A0000A0E61000000200000001080000800700000000000000000000C000000000000000000000000000000000000000000000F0BF000000000000F0BF000000000000F03F000000000000000000000000000000000000000000000040000000000000F03F000000000000F0BF000000000000084000000000000000400000000000000000000000000000104000000000000000000000000000000040000000000000004000000000000000C000000000000000000000000000000000010200008005000000000000000000F0BF0000000000000000000000000000F03F0000000000000000000000000000E03F0000000000000040000000000000F03F000000000000000000000000000008400000000000000000000000000000F03F0000000000000840000000000000F0BF0000000000000000000000000000F03F');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        14, 'Curve Polygon 3dm, SRID=4326',
        'SRID=4326;CURVEPOLYGONM(CIRCULARSTRINGM(-2 0 0,-1 -1 2,0 0 4,1 -1 6,2 0 8,0 2 4,-2 0 0),(-1 0 2,0 0.5 4,1 0 6,0 1 4,-1 0 2))',
        '010A000060E61000000200000001080000400700000000000000000000C000000000000000000000000000000000000000000000F0BF000000000000F0BF0000000000000040000000000000000000000000000000000000000000001040000000000000F03F000000000000F0BF000000000000184000000000000000400000000000000000000000000000204000000000000000000000000000000040000000000000104000000000000000C000000000000000000000000000000000010200004005000000000000000000F0BF000000000000000000000000000000400000000000000000000000000000E03F0000000000001040000000000000F03F000000000000000000000000000018400000000000000000000000000000F03F0000000000001040000000000000F0BF00000000000000000000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        15, 'Curve Polygon 4d, SRID=4326',
        'SRID=4326;CURVEPOLYGON(CIRCULARSTRING(-2 0 0 0,-1 -1 1 2,0 0 2 4,1 -1 3 6,2 0 4 8,0 2 2 4,-2 0 0 0),(-1 0 1 2,0 0.5 2 4,1 0 3 6,0 1 3 4,-1 0 1 2))',
        '010A0000E0E61000000200000001080000C00700000000000000000000C0000000000000000000000000000000000000000000000000000000000000F0BF000000000000F0BF000000000000F03F00000000000000400000000000000000000000000000000000000000000000400000000000001040000000000000F03F000000000000F0BF000000000000084000000000000018400000000000000040000000000000000000000000000010400000000000002040000000000000000000000000000000400000000000000040000000000000104000000000000000C000000000000000000000000000000000000000000000000001020000C005000000000000000000F0BF0000000000000000000000000000F03F00000000000000400000000000000000000000000000E03F00000000000000400000000000001040000000000000F03F0000000000000000000000000000084000000000000018400000000000000000000000000000F03F00000000000008400000000000001040000000000000F0BF0000000000000000000000000000F03F0000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        16, 'Multi Curve',
        'MULTICURVE((5 5,3 5,3 3,0 3),CIRCULARSTRING(0 0,2 1,2 2))',
        '010B0000000200000001020000000400000000000000000014400000000000001440000000000000084000000000000014400000000000000840000000000000084000000000000000000000000000000840010800000003000000000000000000000000000000000000000000000000000040000000000000F03F00000000000000400000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        17, 'Multi Curve, SRID=4326',
        'SRID=4326;MULTICURVE((5 5,3 5,3 3,0 3),CIRCULARSTRING(0 0,2 1,2 2))',
        '010B000020E61000000200000001020000000400000000000000000014400000000000001440000000000000084000000000000014400000000000000840000000000000084000000000000000000000000000000840010800000003000000000000000000000000000000000000000000000000000040000000000000F03F00000000000000400000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        18, 'Multi Curve 3dz, SRID=4326',
        'SRID=4326;MULTICURVE((5 5 1,3 5 2,3 3 3,0 3 1),CIRCULARSTRING(0 0 0,2 1 3,2 2 1))',
        '010B0000A0E61000000200000001020000800400000000000000000014400000000000001440000000000000F03F00000000000008400000000000001440000000000000004000000000000008400000000000000840000000000000084000000000000000000000000000000840000000000000F03F0108000080030000000000000000000000000000000000000000000000000000000000000000000040000000000000F03F000000000000084000000000000000400000000000000040000000000000F03F');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        19, 'Multi Curve 3dm, SRID=4326',
        'SRID=4326;MULTICURVEM((5 5 3,3 5 2,3 3 1,0 3 1),CIRCULARSTRINGM(0 0 0,2 1 -2,2 2 2))',
        '010B000060E61000000200000001020000400400000000000000000014400000000000001440000000000000084000000000000008400000000000001440000000000000004000000000000008400000000000000840000000000000F03F00000000000000000000000000000840000000000000F03F0108000040030000000000000000000000000000000000000000000000000000000000000000000040000000000000F03F00000000000000C0000000000000004000000000000000400000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        20, 'Multi Curve 4d, SRID=4326',
        'SRID=4326;MULTICURVE((5 5 1 3,3 5 2 2,3 3 3 1,0 3 1 1),CIRCULARSTRING(0 0 0 0,2 1 3 -2,2 2 1 2))',
        '010B0000E0E61000000200000001020000C00400000000000000000014400000000000001440000000000000F03F00000000000008400000000000000840000000000000144000000000000000400000000000000040000000000000084000000000000008400000000000000840000000000000F03F00000000000000000000000000000840000000000000F03F000000000000F03F01080000C00300000000000000000000000000000000000000000000000000000000000000000000000000000000000040000000000000F03F000000000000084000000000000000C000000000000000400000000000000040000000000000F03F0000000000000040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        21, 'Multi Surface',
        'MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0),(-1 0,0 0.5,1 0,0 1,-1 0)),((7 8,10 10,6 14,4 11,7 8)))',
        '010C00000002000000010A0000000200000001080000000700000000000000000000C00000000000000000000000000000F0BF000000000000F0BF00000000000000000000000000000000000000000000F03F000000000000F0BF000000000000004000000000000000000000000000000000000000000000004000000000000000C00000000000000000010200000005000000000000000000F0BF00000000000000000000000000000000000000000000E03F000000000000F03F00000000000000000000000000000000000000000000F03F000000000000F0BF0000000000000000010300000001000000050000000000000000001C4000000000000020400000000000002440000000000000244000000000000018400000000000002C40000000000000104000000000000026400000000000001C400000000000002040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        22, 'Multi Surface, SRID=4326',
        'SRID=4326;MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0),(-1 0,0 0.5,1 0,0 1,-1 0)),((7 8,10 10,6 14,4 11,7 8)))',
        '010C000020E610000002000000010A0000000200000001080000000700000000000000000000C00000000000000000000000000000F0BF000000000000F0BF00000000000000000000000000000000000000000000F03F000000000000F0BF000000000000004000000000000000000000000000000000000000000000004000000000000000C00000000000000000010200000005000000000000000000F0BF00000000000000000000000000000000000000000000E03F000000000000F03F00000000000000000000000000000000000000000000F03F000000000000F0BF0000000000000000010300000001000000050000000000000000001C4000000000000020400000000000002440000000000000244000000000000018400000000000002C40000000000000104000000000000026400000000000001C400000000000002040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        23, 'Multi Surface 3dz, SRID=4326',
        'SRID=4326;MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(-2 0 0,-1 -1 1,0 0 2,1 -1 3,2 0 4,0 2 2,-2 0 0),(-1 0 1,0 0.5 2,1 0 3,0 1 3,-1 0 1)),((7 8 7,10 10 5,6 14 3,4 11 4,7 8 7)))',
        '010C0000A0E610000002000000010A0000800200000001080000800700000000000000000000C000000000000000000000000000000000000000000000F0BF000000000000F0BF000000000000F03F000000000000000000000000000000000000000000000040000000000000F03F000000000000F0BF000000000000084000000000000000400000000000000000000000000000104000000000000000000000000000000040000000000000004000000000000000C000000000000000000000000000000000010200008005000000000000000000F0BF0000000000000000000000000000F03F0000000000000000000000000000E03F0000000000000040000000000000F03F000000000000000000000000000008400000000000000000000000000000F03F0000000000000840000000000000F0BF0000000000000000000000000000F03F010300008001000000050000000000000000001C4000000000000020400000000000001C4000000000000024400000000000002440000000000000144000000000000018400000000000002C4000000000000008400000000000001040000000000000264000000000000010400000000000001C4000000000000020400000000000001C40');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        24, 'Multi Surface 3dm, SRID=4326',
        'SRID=4326;MULTISURFACEM(CURVEPOLYGONM(CIRCULARSTRINGM(-2 0 0,-1 -1 2,0 0 4,1 -1 6,2 0 8,0 2 4,-2 0 0),(-1 0 2,0 0.5 4,1 0 6,0 1 4,-1 0 2)),((7 8 8,10 10 5,6 14 1,4 11 6,7 8 8)))',
        '010C000060E610000002000000010A0000400200000001080000400700000000000000000000C000000000000000000000000000000000000000000000F0BF000000000000F0BF0000000000000040000000000000000000000000000000000000000000001040000000000000F03F000000000000F0BF000000000000184000000000000000400000000000000000000000000000204000000000000000000000000000000040000000000000104000000000000000C000000000000000000000000000000000010200004005000000000000000000F0BF000000000000000000000000000000400000000000000000000000000000E03F0000000000001040000000000000F03F000000000000000000000000000018400000000000000000000000000000F03F0000000000001040000000000000F0BF00000000000000000000000000000040010300004001000000050000000000000000001C400000000000002040000000000000204000000000000024400000000000002440000000000000144000000000000018400000000000002C40000000000000F03F0000000000001040000000000000264000000000000018400000000000001C4000000000000020400000000000002040');
INSERT INTO serialize_test(
        id, description, ewkt, serialized
      ) VALUES (
        25, 'Multi Surface 4d, SRID=4326',
        'SRID=4326;MULTISURFACE(CURVEPOLYGON(CIRCULARSTRING(-2 0 0 0,-1 -1 1 2,0 0 2 4,1 -1 3 6,2 0 4 8,0 2 2 4,-2 0 0 0),(-1 0 1 2,0 0.5 2 4,1 0 3 6,0 1 3 4,-1 0 1 2)),((7 8 7 8,10 10 5 5,6 14 3 1,4 11 4 6,7 8 7 8)))',
        '010C0000E0E610000002000000010A0000C00200000001080000C00700000000000000000000C0000000000000000000000000000000000000000000000000000000000000F0BF000000000000F0BF000000000000F03F00000000000000400000000000000000000000000000000000000000000000400000000000001040000000000000F03F000000000000F0BF000000000000084000000000000018400000000000000040000000000000000000000000000010400000000000002040000000000000000000000000000000400000000000000040000000000000104000000000000000C000000000000000000000000000000000000000000000000001020000C005000000000000000000F0BF0000000000000000000000000000F03F00000000000000400000000000000000000000000000E03F00000000000000400000000000001040000000000000F03F0000000000000000000000000000084000000000000018400000000000000000000000000000F03F00000000000008400000000000001040000000000000F0BF0000000000000000000000000000F03F000000000000004001030000C001000000050000000000000000001C4000000000000020400000000000001C400000000000002040000000000000244000000000000024400000000000001440000000000000144000000000000018400000000000002C400000000000000840000000000000F03F00000000000010400000000000002640000000000000104000000000000018400000000000001C4000000000000020400000000000001C400000000000002040');



SELECT id, CASE WHEN ewkt = ST_asEWKT(serialized::geometry) THEN 'pass' ELSE 'fail' END AS result FROM serialize_test ORDER BY id;
SELECT id, CASE WHEN ST_asEWKB(geomFromEWKT(ewkt)) = serialized THEN 'pass' ELSE 'fail' END AS result FROM serialize_test ORDER BY id;

DROP TABLE serialize_test;
