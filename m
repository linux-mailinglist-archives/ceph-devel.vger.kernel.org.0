Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4D1376E6C
	for <lists+ceph-devel@lfdr.de>; Sat,  8 May 2021 04:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhEHCOR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 May 2021 22:14:17 -0400
Received: from mout.gmx.net ([212.227.15.15]:53673 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhEHCOQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 May 2021 22:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1620439995;
        bh=lZyId1GYICZ2ygP+pTZ490926ssNo6EVcWKfbmumiyg=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=PRjHOuB63U23Spt4DmqCroS+hqCa2C0FWvhReEa/NJ8zGVykG1A+zfDdeWkCWN2Q4
         yv8Kbu14FNcHjx0wpkSvNlrYOEEtlc07GqYJbB5hWycGX42/w8lV0TJtrFlS8uZkTY
         e7Ge4AdWv9PIFO1OBGC+MUtINayAL3Fcirr5mb0E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.25.136] ([103.52.188.137]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MNbkv-1lunGj2LP9-00P4iW for
 <ceph-devel@vger.kernel.org>; Sat, 08 May 2021 04:13:15 +0200
To:     ceph-devel@vger.kernel.org
From:   "Norman.Kern" <norman.kern@gmx.com>
Subject: Ceph Kernel client bad performance for 5.4
Message-ID: <4badb69d-515f-ec30-5966-d26e145884bd@gmx.com>
Date:   Sat, 8 May 2021 10:13:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:sg340bw2rf1ThpvG+8iflvJoDo9O7EQXgjeO52K2labSOa1kqFe
 uH5fL6PGE53uBfuy3SIOy/ZAkHhXyZiYvODpFYbD1ePd1tIYG9Sps+/2a56blg/r0ZAPYbJ
 1+RKATu8D1gxm5UbrAhfDxaBwlKHh5Jpa+Q7FDBpMHm9aVZEIE6BAh9G0gHnlDEKSqKyOKu
 Us4ZNj9p0gsyaMp0uicsw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:38nyJsG6EtA=:dbIYTrWiD+tqwnSiJ9nCXW
 dWtKFP5UFAJMKNTWje3M1vXPcRdXSa2KZAgqR5LPzcdZ7qUiDTcZKhXQrRYLdTJSXmBR1+77t
 abTDIPsR/wWKdnU8nTWDeBu8gYN3tWOqzOw6XrND2kicB+E1JoppE+whORhVXUa32pehfwg90
 VDDE78WMyyt4UJPlrhROZ3bRSwfci4th//EdeRbgdZ7jrHcjEueWKvETTPdhdGNCVsWiFwcar
 PPprliaCT89s1Tg13c0uzS9k8cCxaW8gb5FOg+jWxJEl/1/j+BLHGdO9m1utyALY4YZdHf2SO
 itmp8CKQyzPm8DQsdDQv93mDHV8El0gGZaBSLW7ngbrwn3XyuzCBczk4n2QDRVtsJJHs9U5y6
 m9kw6o8jgac/Xx6K25KSebcgS3CJHaR8hHLVhdidr3BH6tAKT3FZQCcvm6sfQHnby7wVWTM6E
 ndD8j+weTjopQWWfg8pXpc8IF1eEmID1EUIlMiFEVxEt0meSuEvGSJCn2LjIsy7wopvIR+Kw1
 IN8/O7Y+o8A8NCblTh0atR2CRACgP3okGTHhWi6SoMLhjz+2rkzzEJHSPH3JFSkWl1qEbu4yq
 /yxMV5FZ8djjY/w5uEhXnDPffIPB3D2k8j/1yS9eWw0WHbymOb2oZk+vAGTptd5lRaHgUv4Wb
 8DgPrIva2M7vIzuPZK29k9VhZSrX6xZeFshVgWrtf7/uhQe3Jehhm0iMDpj6M6dzLmL7LEri4
 qjh3Xip3XBzGr+DzCMN3l5+p5v+NZpzJ8SAGV5tCMSs+pbuOtIQn/jdJYe/YZ0+7FzxgHeL5D
 ts6RKZPUvULKeFFB6lvG5H96omN7QKAWeWGWV83taqLwHswDII3GR4NHDKvdWHkz4bQq1Ba59
 QSFWjrJ7SQ5Dj07NNOtGgVXmDUJM9rROqpupYc0+A4qPcRjM/WL1HXx3+Td/cDSOfDPY4sjuP
 gu++i+solkd1CkyoDff5rAgZ727qQDWevIqZV9zoRV2XlbPtzN/3+CUCD2XNNc+xQ09iI28CS
 4cqDaA3GYUc6drRe9oG4wwynlN25bpdz3Qq9g7l1dH/DS2E8ORl5BpNfP47uOpJQbdjHUM4Qw
 ksP9p92H3ytRo/ZtRH1c+YuDIXl9x8HXDITsu1nV3ZQ1F1kdYekccfu3wl5zORcg4c3qxbpIY
 7iJ2TBNjTOCjuJjBf9UQHcXhBSjqImi0Ruf/R3rnWcnRDYJzba9x7Y9eeEqFLN12sSREM=
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi, guys,


I'm using ceph nautilus in my production,=C2=A0 the kernel clients include=
 5.4 and 4.15, I found a problem in 5.4 sometimes: It's slower than fuse, =
but when I changed it
to 4.15, it's recovered.
for 5.4:
root@WXRG0432:/mnt/test# rsync -ahHv --progress /root/test test-1
sending incremental file list
test
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 58.56M=C2=A0=C2=A0 5%=C2=
=A0=C2=A0=C2=A0 2.82MB/s=C2=A0=C2=A0=C2=A0 0:05:43=C2=A0 ^C
for 4.15:
root@WXRG0433:/mnt/test# rsync -ahHv --progress /root/test=C2=A0 test-2
sending incremental file list
test
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1.05G 100%=C2=A0 31=
6.25MB/s=C2=A0=C2=A0=C2=A0 0:00:03 (xfr#1, to-chk=3D0/1)

sent 1.05G bytes=C2=A0 received 35 bytes=C2=A0 299.67M bytes/sec
Anyone have met the same problems with me?
