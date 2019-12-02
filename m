Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC0010EA94
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Dec 2019 14:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfLBNNC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 08:13:02 -0500
Received: from mout.gmx.net ([212.227.15.18]:53227 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727386AbfLBNNC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:13:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1575292378;
        bh=TJuoaevhHU1zdo+3MbO+IXJ2AdjntuXocHJFM7FzJeY=;
        h=X-UI-Sender-Class:From:Subject:To:Cc:Date;
        b=I4boSX5Rjo4ejAWt9DUlIMlLrRwz9GJyDJqrnJ8zxq6Y4IGYbCfvPC1OaYnGOr4f/
         ze78QVkDLIEYDRwSnFSwcGdS48uoHZmvhC1JLVtIDU/doEx/94BbWi9flkLwet2eUx
         Pp72JW38Her9Po7rgUJXR6eJsk6jVt7fJM/4NFwo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.25.124] ([103.59.50.2]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M6Ue3-1ii65r1dZB-006zwb; Mon, 02
 Dec 2019 14:12:58 +0100
From:   norman <norman.kern@gmx.com>
Subject: [BUG]cephfs hang for ever
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com
Message-ID: <e81c2147-f2f0-bcc3-87fd-ec2fc1554c3c@gmx.com>
Date:   Mon, 2 Dec 2019 21:12:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:ei8TqbXo4c8239nq8PosA8E6FuzQQAxCTVfAYbIExdpyn9l9du+
 zTz3u/4hLiDT+dgWFAKqbdGvw9m9kXpqQ3tJJYQ5fIaseotIIy/zdII4CTGzILi34WSr0NI
 W08d40Jwj7fTDeWy6ygj8Bmi7QEb6IWskxcSLPEKUnU+2jwBoWgCbXNcUiacOhDQoo4PwAZ
 oa5wu/j4i51qvUTSfcnrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EifrLYcP0cw=:rfrXVJF5bxxNP+QSIz4GnT
 2FgpM8IfFMmaxJoYjjdlZrW91LLaQBJZSz5MrS6VcfyHRB17GLRscqXxdO+A3+5fW0UfbiB3U
 Hvp9YxqGUl3v+siYfMbvT2QzDc5gn02rbxy7eH9Aw5LCTDA5U9guf+Wb0o8P4/2E5Z4pcHF+3
 teS6lYIFe/b8tN5xH5sBZigFQuK06tCtC35UMA7pjGruj0hHf0sjfvjTzas7JK4NeVmFOgzjo
 +Ir+vBKTgOckDjVS4Dl5uBNCYsE/SubujadhvBvg96lHXyd96EcGFrrez686P4rNtFxhIgUte
 LiNPpHVV17Y9o/JaOn6g52zKiBg9ER6W+cG6DHKARht8YO9TbLUQ3CDtH+pNO4xwEB4SXrB3F
 5cORCOgj54XJVDl8+BjvlMGfPvOxADQoXu5lx89Mki4WEL7/pjXhEemS9PJ+SJe68U6osL8JF
 YvJnzqv+l9T1MyzY/9WdO0YGmkIdtC5jWYpsYPDYNBWaSnqitessCj/3vm7zyZXKBv7hwxRdS
 ru4Ms47s41RucUhyv2Gy1GvT55ZoL9nIz8crHP8xQ3D8QGW7Ywahdn7dPDyhUFp7C8lGo1hVN
 C0SF72q1yjXXXo03NZUJKbXTJSDz68nrYZfFpSblGI2FXXzeTTfeUOqqZQxvVuX2W7whzJnAX
 yqhl2FyBh6LuvtJO5JGgnLst6fsYawyg5wW4gtVmv/WyAvnz0dpMyoAsZlgSXGcGeYhjjUefr
 EVgPYig22Y3QSvU9SE/wAbVGK3huGQuqxXwRIqSQMdoOQUVeHZli0c1sZFgjeSA3ST+g3clHz
 kjtJQUZ8C+Aw92GVfL5a5+6UCLi9V5lVgw79/kG59y8sL1BU8bxVkrE/uc/DfCqB09EIiPjFK
 mQRukfyziUT+pLSTVbm75cYr/dWuQpHmd9ZeMNMvPIvTcyNofb+MDn6wLpF7HZhJ+rp7h1Yzg
 v9Myf7kNpzVHynGw6ktTbkgDYSBzfTOxhWtDKxelEsiMiREVGTqnN4f7Aw5T7YpvNu3LfKuYr
 LfJf0f1R2ktRZ7EArZdIfrxCa0kzRjphy7757RQYlbggGyseOP+oOL7HTjrHa2sxlt+Afk9vu
 Aa2qJ8ZTQ306N8kYrBsLqkPygcOig4G2dHTYYllRP4NCMXVOjjvRHUTOT2BtE4OqtGle2zx/L
 qCJZuRXUXg5rAoHqCvBhRuzHsdNAebEH2YDQRKP8PRDA52Npo0Wzy8qChtweqvWwomJBKEEE4
 a3nyBoGEi3/LqgcjRVCW5w9Tgxyw8ZblEYFpX3uLe7lFh3ZStrh52oOldXO0=
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I found a problem in my cephfs kernel client,=C2=A0 a thread hung for days=
,=C2=A0
and I check the stack

debug-user@CEPH0207:/home/debug-user$ sudo cat /proc/46071/stack
[<ffffffffc0e8fb60>] ceph_mdsc_do_request+0x180/0x240 [ceph]
[<ffffffffc0e70e51>] __ceph_do_getattr+0xd1/0x1e0 [ceph]
[<ffffffffc0e70fcc>] ceph_getattr+0x2c/0x100 [ceph]
[<ffffffffbc05b943>] vfs_getattr_nosec+0x73/0x90
[<ffffffffbc05b996>] vfs_getattr+0x36/0x40
[<ffffffffbc05baae>] vfs_statx+0x8e/0xe0
[<ffffffffbc05c00d>] SYSC_newstat+0x3d/0x70
[<ffffffffbc05c7ae>] SyS_newstat+0xe/0x10
[<ffffffffbc8001a1>] entry_SYSCALL_64_fastpath+0x24/0xab
[<ffffffffffffffff>] 0xffffffffffffffff

and I found the the session has lost its connection,

debug-user@CEPH0207:/home/debug-user$ sudo cat
/sys/kernel/debug/ceph/64803197-c207-4012-b8f3-18825d34196c.client15099020=
/mds_sessions
global_id 15099020
name "text"
mds.0 reconnecting

I guess the client has been in the black list, but it's not, someone can
give me some ideas about how to solve the problem or it's a known bug?
Thanks.

The envrionment info:

OS: Ubuntu

kernel:=C2=A0 linux-image-4.13.0-36-generic

cpeh version: luminous

