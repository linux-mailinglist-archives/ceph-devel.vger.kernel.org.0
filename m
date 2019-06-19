Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA0C4BDE4
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Jun 2019 18:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfFSQTD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Jun 2019 12:19:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40919 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfFSQTD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 19 Jun 2019 12:19:03 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so4045107wre.7
        for <ceph-devel@vger.kernel.org>; Wed, 19 Jun 2019 09:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IlHPTuAUtNYvAoAWw6g7RJT7lrixbDlSqbfcAiAepkc=;
        b=LF7YCzVNXyWoPz/R1gbZuK1nJdB0iOM+tPZxDu3KeBdQpRIP/d7RHULhpQAAgqaOVq
         JjBZig2gBtRu+fq6PzIFCyFeARQ8ODgIvBkPuet74SEs5Q8peT/iSxxm5OCLODY3BXKY
         3/G4Kaiq2dnxJZ0pPGvfgtWjHYVawPajyNIODMYHhNViwAMWkhXw+1DjlBZgNxOBeLdn
         2dJbjxVV+XUDL3QIiMg0D9qDh/0cP5GzcuBTuDMMICqjFPAvznSgYXOCXOO069DSpRYu
         rQTdmp08I3AkBMOp8t/Le0OKBPvxzPeHBmTUpSnRkCZeS4cDOWcY2yA/P/M0r+t1v9UY
         lA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=IlHPTuAUtNYvAoAWw6g7RJT7lrixbDlSqbfcAiAepkc=;
        b=Y30+yVIENH9aaRya4i8b4n4aZivgXlUyBWL1NswQSUU6jOpuf9YdSN1lFIKcI794mj
         dL86ojNIQUtOcEn/DE8WRtAyqmPp4D/Xa55Qiba1U5TwZS0OPifHABjeRwuZ3se4pmHw
         E10+n9aI2ul6qTDuYdhVBBgIZ2RWtoe6PzVsBAImMwmHANGQqKGogKmLmqe/936hic+G
         /EfAQIk5T4cFRrzLX3J0/mEMcszCYYRUxfzvZ8wlJAMYikjz5l+8lYLp2uo9UJE82xcN
         PDKdubPv4LbU+t42vUnIonUC2z3SuoN68w7unMqfSaJNVfxn1aEH4WU4mfYtV7eo/HjL
         PnyQ==
X-Gm-Message-State: APjAAAXdu1zR7H9kgJ6Cjtfj7GPsaBnmUME39PQztcuvoAdOLDTpLOlC
        QheY8CmEWl7VnCg5O9rnMnLSHBhzSnbPh+SF2DZtXf9/
X-Google-Smtp-Source: APXvYqyBTbJ9n+snY0amrN1jFTXIfg0XbiI8dFg+aOsnC5Vjh9fqf34AO30V0TfXrwRjstpuRCQVhma3Q7orejaHsog=
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr9269766wrj.37.1560961141558;
 Wed, 19 Jun 2019 09:19:01 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Jin <wjin.cn@gmail.com>
Date:   Thu, 20 Jun 2019 00:18:50 +0800
Message-ID: <CAPpSHbUz2GmtnND2ptUaiSD2JgagBxsPkguUkhE37N6UHFRmHw@mail.gmail.com>
Subject: CephFS damaged and cannot recover
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@lists.ceph.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There are plenty of data in this cluster (2PB), please help us, thx.
Before doing this dangerous
operations=EF=BC=88http://docs.ceph.com/docs/master/cephfs/disaster-recover=
y-experts/#disaster-recovery-experts=EF=BC=89
, any suggestions?

Ceph version: 12.2.12

ceph fs status:

cephfs - 1057 clients
=3D=3D=3D=3D=3D=3D
+------+---------+-------------+----------+-------+-------+
| Rank |  State  |     MDS     | Activity |  dns  |  inos |
+------+---------+-------------+----------+-------+-------+
|  0   |  failed |             |          |       |       |
|  1   | resolve | n31-023-214 |          |    0  |    0  |
|  2   | resolve | n31-023-215 |          |    0  |    0  |
|  3   | resolve | n31-023-218 |          |    0  |    0  |
|  4   | resolve | n31-023-220 |          |    0  |    0  |
|  5   | resolve | n31-023-217 |          |    0  |    0  |
|  6   | resolve | n31-023-222 |          |    0  |    0  |
|  7   | resolve | n31-023-216 |          |    0  |    0  |
|  8   | resolve | n31-023-221 |          |    0  |    0  |
|  9   | resolve | n31-023-223 |          |    0  |    0  |
|  10  | resolve | n31-023-225 |          |    0  |    0  |
|  11  | resolve | n31-023-224 |          |    0  |    0  |
|  12  | resolve | n31-023-219 |          |    0  |    0  |
|  13  | resolve | n31-023-229 |          |    0  |    0  |
+------+---------+-------------+----------+-------+-------+
+-----------------+----------+-------+-------+
|       Pool      |   type   |  used | avail |
+-----------------+----------+-------+-------+
| cephfs_metadata | metadata | 2843M | 34.9T |
|   cephfs_data   |   data   | 2580T |  731T |
+-----------------+----------+-------+-------+

+-------------+
| Standby MDS |
+-------------+
| n31-023-227 |
| n31-023-226 |
| n31-023-228 |
+-------------+



ceph fs dump:

dumped fsmap epoch 22712
e22712
enable_multiple, ever_enabled_multiple: 0,0
compat: compat=3D{},rocompat=3D{},incompat=3D{1=3Dbase v0.20,2=3Dclient
writeable ranges,3=3Ddefault file layouts on dirs,4=3Ddir inode in
separate object,5=3Dmds uses versioned encoding,6=3Ddirfrag is stored in
omap,8=3Dno anchor table,9=3Dfile layout v2}
legacy client fscid: 1

Filesystem 'cephfs' (1)
fs_name cephfs
epoch 22711
flags 4
created 2018-11-30 10:05:06.015325
modified 2019-06-19 23:37:41.400961
tableserver 0
root 0
session_timeout 60
session_autoclose 300
max_file_size 1099511627776
last_failure 0
last_failure_osd_epoch 22246
compat compat=3D{},rocompat=3D{},incompat=3D{1=3Dbase v0.20,2=3Dclient writ=
eable
ranges,3=3Ddefault file layouts on dirs,4=3Ddir inode in separate
object,5=3Dmds uses versioned encoding,6=3Ddirfrag is stored in omap,8=3Dno
anchor table,9=3Dfile layout v2}
max_mds 14
in 0,1,2,3,4,5,6,7,8,9,10,11,12,13
up {1=3D31684663,2=3D31684674,3=3D31684576,4=3D31684673,5=3D31684678,6=3D31=
684612,7=3D31684688,8=3D31684683,9=3D31684698,10=3D31684695,11=3D31684693,1=
2=3D31684586,13=3D31684617}
failed
damaged 0
stopped
data_pools [2]
metadata_pool 1
inline_data disabled
balancer
standby_count_wanted 1
31684663: 10.31.23.214:6800/829459839 'n31-023-214' mds.1.22682 up:resolve =
seq 6
31684674: 10.31.23.215:6800/2483123757 'n31-023-215' mds.2.22683
up:resolve seq 3
31684576: 10.31.23.218:6800/3381299029 'n31-023-218' mds.3.22683
up:resolve seq 3
31684673: 10.31.23.220:6800/3540255817 'n31-023-220' mds.4.22685
up:resolve seq 3
31684678: 10.31.23.217:6800/4004537495 'n31-023-217' mds.5.22689
up:resolve seq 3
31684612: 10.31.23.222:6800/1482899141 'n31-023-222' mds.6.22691
up:resolve seq 3
31684688: 10.31.23.216:6800/820115186 'n31-023-216' mds.7.22693 up:resolve =
seq 3
31684683: 10.31.23.221:6800/1996416037 'n31-023-221' mds.8.22693
up:resolve seq 3
31684698: 10.31.23.223:6800/2807778042 'n31-023-223' mds.9.22695
up:resolve seq 3
31684695: 10.31.23.225:6800/101451176 'n31-023-225' mds.10.22702
up:resolve seq 3
31684693: 10.31.23.224:6800/1597373084 'n31-023-224' mds.11.22695
up:resolve seq 3
31684586: 10.31.23.219:6800/3640206080 'n31-023-219' mds.12.22695
up:resolve seq 3
31684617: 10.31.23.229:6800/3511814011 'n31-023-229' mds.13.22697
up:resolve seq 3


Standby daemons:

31684637: 10.31.23.227:6800/1987867930 'n31-023-227' mds.-1.0 up:standby se=
q 2
31684690: 10.31.23.226:6800/3695913629 'n31-023-226' mds.-1.0 up:standby se=
q 2
31689991: 10.31.23.228:6800/2624666750 'n31-023-228' mds.-1.0 up:standby se=
q 2
