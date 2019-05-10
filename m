Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7880F19D13
	for <lists+ceph-devel@lfdr.de>; Fri, 10 May 2019 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfEJMP0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 May 2019 08:15:26 -0400
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:56166 "EHLO
        mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727071AbfEJMPZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 10 May 2019 08:15:25 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 May 2019 08:15:24 EDT
Received: from pps.filterd (m0075029.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ABs8sk035852
        for <ceph-devel@vger.kernel.org>; Fri, 10 May 2019 07:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com; h=mime-version : from
 : date : message-id : subject : to : content-type; s=proofpoint;
 bh=JsSgM1XUmcEfpZYltJS0nTYMqlwAL9V4lQlorPX+/AE=;
 b=3CCHE9od99Bt6VvAzXLN2lfo96Jp1vs/VJf4PkiUf5WJBfk2YgWf4BukBI1NCDywN58Q
 rYepHEvOU44dKBLJOVPksRtdfYja4MnVtxcZquC9AwvfGn7wpXgT4/ZzCEFuHubfmT9i
 DJH+2n55ySy6D3kPn2I1Ploz9GXjHU3B39BeoGquCq4NgDxeJFcL7zEma32vbjS3+r/p
 9xH3Kh94TNg+3OrWkMP4vZ39rw1xGW8K1+SezssOpfLom2EU7N8oU3IAAtMHzlVbvxbE
 VEd6fZOLCJKf71ThEZYOAN9RgBh8MDjZNIgu6Ocge7LoMz/hMjTdyHAN6QLkwpjIDTsT mw== 
Authentication-Results: seagate.com;
        dkim=pass header.d=seagate.com header.s=google
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        by mx0b-00003501.pphosted.com with ESMTP id 2scb8n8tew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <ceph-devel@vger.kernel.org>; Fri, 10 May 2019 07:58:03 -0400
Received: by mail-ed1-f72.google.com with SMTP id c1so3842830edi.20
        for <ceph-devel@vger.kernel.org>; Fri, 10 May 2019 04:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seagate.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=JsSgM1XUmcEfpZYltJS0nTYMqlwAL9V4lQlorPX+/AE=;
        b=IlZtZsgdZSw892qS0n0Xh3du2ZFGBZGRt8PUG+Lhb8mpgkR3CztaG4KwD1B+KbBYKm
         Ry8TLuUQCOKJsMM1IXgSmYXG9eZBEtXuz0bvVDH7WnKrK+o2taD+oatFa1p5Xqv3aDkm
         trl5xB95EJs53TF8wIvQfOaQD+gFkUkmDTYm+tT0m09HS9O/DrzfrWtkU2sbQl9V9vMu
         fgDpYU1wneiB2NLpWr8WecUsvDO7LS2V0qz16GvvEq1WtgrKhFYQqU8sGFO/GRZyqAuX
         UjBpzWd2NxGVVXsnZs8IgorYpd5kRxl2rcbC8Edc54CoDrnAMFItp3yqhyHsY1HYjLcY
         BmPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JsSgM1XUmcEfpZYltJS0nTYMqlwAL9V4lQlorPX+/AE=;
        b=myszgmk2tegI93CzHK93i+wIQd0IDOG8SZeyg4/j3UPeYLhLLy9cCdqMXX5EaNA4gn
         5BOMgbXbek1/mocvopHecwaQApVfDdbOcSh2cbEMhoFERosFL9PB65+eJHfSstXA5C0f
         mn/vP15pckMuvtqOI53e0tau6FB9jtAX8D+96Dgd03/SGuNK/6Vp7FqBscQgS9MwiPYQ
         H0iGy0OAiFmk8FKP8rSlqWHgby7SeaNLXf/FrJSs+T31wyNQkhMLvHjWKgIKd1D9SosK
         wJwWznWhr5GABUJN5pyVh5+48BDDCk/PuyTiuEaRWBEChHOPxng1rTaeFSWKReEqkpdZ
         /ubA==
X-Gm-Message-State: APjAAAVDH0H1s4W66hD5Wa/5Jn0vGx3gxJ/A65qqX580/YEn/gpI7cb2
        RC0aOrrLji/Fifhw7K9Q0jZsS4hPaQlNuPVhcsed7SWpc+rKkhUCvQDl3hVG59AJUw5sEUlcCzO
        v9Pa1LrY3jOXcLeid0BRqyvc1HpmshZlAqJIOW+p3qc3WHOlNYJJYETWG9bisQZs=
X-Received: by 2002:a50:bf0c:: with SMTP id f12mr10479103edk.181.1557489481415;
        Fri, 10 May 2019 04:58:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVLSZ80q1MVB9qseTD8ibGT/HMNQR39Be5E7tQZco3Auww/khmR6mTf48wqbGLwjAnb2a9114w67h3xpXKu/0=
X-Received: by 2002:a50:bf0c:: with SMTP id f12mr10479088edk.181.1557489481170;
 Fri, 10 May 2019 04:58:01 -0700 (PDT)
MIME-Version: 1.0
From:   Muhammad Ahmad <muhammad.ahmad@seagate.com>
Date:   Fri, 10 May 2019 07:57:25 -0400
Message-ID: <CAPNbX4TWbHD-otnugx6tHKQuot5RinzvWsMV7zVK2yPq9b0cZQ@mail.gmail.com>
Subject: Supporting ATA/SCSI/NVMe pass-through
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-PolicyRoute: Outbound
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=961 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100085
X-Proofpoint-Spam-Policy: Default Domain Policy
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Folks,

What library or command line utility does Ceph uses to send raw
ATA/SCSI/NVMe commands to the physical storage device consumed as an
OSD? In other words, a library/CLI that uses SG_IO ioctl to send
SAT/SCSI commands to ATA/SCSI devices and NVME_IOCTL_ADMIN_CMD to send
NVMe commands?

I looked into libstorage but it's seems like a library dealing with
logical management.

Some of the use cases such a library that can send ATA/SCSI/NVMe
commands would be able to handle are:
- Changing the power mode of devices (e.g. a policy that an
orchestrator sets for every OSD consumed by it to be always set to
standby_z)
- Changing the write cache setting of devices (e.g. a dashboard toggle
switch to set the OSD write cache on/off)
- repurpose or erase a physical device using industry standard crypto
erase supported by all three commands sets.
- extract telemetry or crash dump from device using standard logs
available in each command set.
- much richer device information page on the dashboard, that includes
physical drive capabilities, settings etc.

I can think of a number of other use cases where such a library will be needed.

If such capability doesn't exist in Ceph today, may I recommend using
opensea-api libraries?
https://github.com/seagate/opensea-api
There are command line utilities built on top of this library, called
openSeaChest that do perform the above use cases I described on direct
attached devices.
https://github.com/Seagate/openSeaChest

Thanks,
-Muhammad
