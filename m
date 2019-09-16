Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAC8B3721
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Sep 2019 11:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbfIPJ25 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Sep 2019 05:28:57 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:42225 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbfIPJ24 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Sep 2019 05:28:56 -0400
Received: by mail-ed1-f50.google.com with SMTP id y91so32427548ede.9
        for <ceph-devel@vger.kernel.org>; Mon, 16 Sep 2019 02:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WrVaC9CclMec8sOCjBR06Oavk5JaSSzG9uJJ4rgwMIg=;
        b=fewtFX2APxWoAcwNY9tuzQ/pDpgqTxYeXkXkVVO6bbBI/h2zR0xoKYwYJrWiNcvi87
         hWU4GHdELEhO/uRmSVOCjvECHArVjE5PZ/IftUX33s4eOArF+/3hQol6QYd9xkfVDljc
         OAvMJ83KhUEDimykeSFikyIxbCLl+bTPq5DQJmEjb3Xdf1q3JY+2MiygMnrZSclFcBon
         LBYGDaisVABI2XO3ZEuYCnGP1h0a96yT9+MHeI+TOo+SGLOW8HpycYc7OQU/ALLVcpWm
         2OOnMISGaDtPmyrykydJ9hcdq0Lp2CmSn4/kMkByw4Ei28MOsJaaa0Ow19YcKw6fA+uq
         ijvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WrVaC9CclMec8sOCjBR06Oavk5JaSSzG9uJJ4rgwMIg=;
        b=QurFQ/WjXOtBUFWJISFnYPHOFNqxpy9tLJ0GMzWof9QBxK6rhS7kbW4v7e4y40UCYs
         /BZ2HYa29A7dUWVjQfHkN2Ubu21ZW6zuOFRDOiThl6WcyUcTAhPAeMoXJHazlKpdJZGT
         39vQuXo7Iz6XVUwcIU/iKYkU0q1htz9sKuBVhrzFxKC9RafSWqJWKakbjtYKpZYksM9Z
         vHtAwRQR/+E5/Ta6yHI6jOLPtOJ4kyA6uuwx/7zrU97ujIf+rW1tFeZRnDgYrLtaz+QV
         nGwxNDQMuFAsG1M0ZWX8tzkQ5/XgLbcndZLOGO8Vf7/c+qQnjRzNbq7X9W0asEjangTX
         2REg==
X-Gm-Message-State: APjAAAXsVr4j60nbOu99/poNMJi+cR6vV2AXv6QZpExTZvW9AAk/6R+/
        sszm1PjD870Uz2z4s37NSByLXNN2S/i02PuzdxNBN17s
X-Google-Smtp-Source: APXvYqz8hzI2KbcRDjf5uA/CCKquRs7T2yQbjrWCAVnVwzw/Fq2Jngjk4HWtIWuo4gxcGkgWDPLVHxUnlzSSLvFKbmI=
X-Received: by 2002:a50:c351:: with SMTP id q17mr23113237edb.123.1568626134866;
 Mon, 16 Sep 2019 02:28:54 -0700 (PDT)
MIME-Version: 1.0
From:   lin zhou <hnuzhoulin2@gmail.com>
Date:   Mon, 16 Sep 2019 17:29:08 +0800
Message-ID: <CAKO+7k0U-zphb0zfw6nderdJwGvw1YwUhQWU0WnEVsKzcYpgiQ@mail.gmail.com>
Subject: s3cmd upload file successed but return This multipart completion is
 already in progress
To:     ceph-users <ceph-users@lists.ceph.com>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, cephers
recently when using s3cmd to upload a large file, last POST request
which meaned I have finished mutltipart upload.But in fact file upload
success.

some key points:
1.s3cmd send the POST request.but the server response spend 30s;why
some times this POST request need 30s to finish, most of this POST
request finished within 100ms
----- did it mean we face a performance bottleneck? we used ssd to
store index pool.
>  ceph version is 10.2.11
>   42 nodes, each has ten 8T sata and two SSD,
>    .rgw.buckets.data      61      899T     96.58        32644G     423943616
>    .rgw.buckets.index     63         0         0         7025G          5472

2.s3cmd retry send POST request which do not wait for the first POST request
3.why the server return 500 when send multi same POST request, how
about return 102?

the request list is below:

## nginx1
10.200.59.145 - [16/Sep/2019:14:00:05 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploads HTTP/1.1"
200 303 789 "-" "-" "-" 0.191 0.191

10.200.59.145 - [16/Sep/2019:14:00:05 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "PUT
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?partNumber=1&uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 200 0 15729218 "-" "-" "-" 0.511 0.383
...
10.200.59.145 - [16/Sep/2019:14:01:07 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "PUT
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?partNumber=99&uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 200 0 15729218 "-" "-" "-" 0.511 0.383

## nginx2
10.200.59.145 - [16/Sep/2019:14:01:09 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "PUT
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?partNumber=100&uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 200 0 15729220 "-" "-" "-" 2.430 2.298
...
10.200.59.145 - [16/Sep/2019:14:03:43 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "PUT
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?partNumber=349&uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 200 0 1857220 "-" "-" "-" 0.160 0.155
10.200.59.145 - [16/Sep/2019:14:04:13 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 200 360 30520 "-" "-" "-" 30.225 30.223

## nginx3
10.200.59.145 - [16/Sep/2019:14:03:56 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 500 291 30520 "-" "-" "-" 0.012 0.011
10.200.59.145 - [16/Sep/2019:14:04:02 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 500 291 30520 "-" "-" "-" 0.012 0.012
10.200.59.145 - [16/Sep/2019:14:04:11 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 500 291 30520 "-" "-" "-" 0.012 0.012
10.200.59.145 - [16/Sep/2019:14:04:23 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 500 291 30520 "-" "-" "-" 0.013 0.013
10.200.59.145 - [16/Sep/2019:14:04:38 +0800]
"hba3-backup-data0004-f.s3.nie.netease.com" "POST
/yaz4nalmsgsam8kfk5doca/backup/_realm_data.tar.gz.0?uploadId=2~v6s8KbNeMA7RaXS_ntcUPtfP1BmXVr1
HTTP/1.1" 500 291 30520 "-" "-" "-" 0.013 0.013
