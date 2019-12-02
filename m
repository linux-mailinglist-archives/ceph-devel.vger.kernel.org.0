Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2DC10EABF
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Dec 2019 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfLBNWy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 08:22:54 -0500
Received: from mout.gmx.net ([212.227.15.15]:33305 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbfLBNWx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1575292969;
        bh=LgNVBVbE6D5Qlj8QoAVRh1ICQ98mgZj6q7j69D+NgPY=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=SOMw+HB8ysCLfhbViosT4Ol7QxA5e7eb99Efq09pROu+Da4GYDg/2NwQWZZFypKWp
         QQc5TFuDNcASfNY5qF3WZ5LijEjMVaHEu65nx7KiAw1UdZnWKGcSwgIbAljV18zKs4
         LEOxBi/KZ4wRVcVY35LVoioyDebYgPls/RvThSgQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.25.124] ([103.59.50.2]) by mail.gmx.com (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MkHQh-1hvsSO0R0z-00kgIN; Mon, 02
 Dec 2019 14:22:49 +0100
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com
From:   norman <norman.kern@gmx.com>
Subject: [BUG]cephfs hang forever
Message-ID: <7e0d0252-0b60-e3c6-1ac4-36b27818ecaa@gmx.com>
Date:   Mon, 2 Dec 2019 21:22:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:OGNCrFcBIEel8Y5ACgdZlHkPk206dGYhhEaKajaku51h0kKbnv7
 gPPNVeNZ5p0uP6PL/FP4C7hRyXlc9BLuJQ4As+rB38ZFb905bw01IQaUMjan06UScJs3E6K
 GihSk6YqJE51mw2Z98ushqQgmV3yjQ+DoVHphBfE+BQl/PKjweAdNHWhvMwCbKo53uNSxne
 ZQTJHzEkvU+c33pN59Mxg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DDK3uG7j1aU=:6WX+fow6uAR4IQ6Xqb2rVd
 eoUeggZmwNtShERaceBHctcU7l9QTlkLq+y9atVT+LSFZ+tzKsWjaq0QZBoxGkWiNqzDdbTZh
 1JwolutdZbCELX5esxVwpvuywEgm4Zw9769AS7Vz+ARoVjqI+NIAzy3Ap9x+V8BSvW8Qh/A+t
 jl7CH5zGSEiqANUq/LaaH9QTUEdmMYY8RxxXHZJqrM3XBZtx+HPDagKnUWMv4CsGesOHA93lu
 RPpXKAby09iAcLOyG45wjObngpbLQWPRWKwnSr3pZa0Gm/1Oj4abO8Z94EQrT+4UdreU9TTFX
 msw0U9Rl/1PgpeqhZKEOXbG0oT1UWiGIygEPUHrmzo0ciiPYvB1I/Zxwk1JOAYtyn2Ck1ptQz
 57xegNVRsM7qoGF/QgsNckSH3EI+niG2iLuKcyo1yuAd5hjktp3rdd3wD+L93gJ1d0Ski+Lop
 n4PqZ3QWzChehkvDAvg4ulyrkuATW6olwLcC6WTKhgtjjbpTujTnlreXs4cfmLIa7tKWtTpeO
 erzx/Z+rvmlzIl/tp8SOZPtWK7Q1Co6uLQ3Hei4OSGNzhN+1JFB7vokmPp+EAo8ptccpzoxjT
 EhGvH0t5zxulQI95L+jIG/fXPGksBpgf720vJkoYvgK539z/jlEce4tnSgvAS2Oxp2VozSwa2
 8UNzBH/mHCX8FhZ2ycZeo2nIAN8huJ+v1CCZm9uFI2sv2LN35UyDrQ3u1o8jbV/CrEOLRu0gk
 LcIv0ha15GLtSXyPl8upfzIElkXG3h0Hbx+GN/5fayGDiLVRtYEViOgISnTCiq77bi5AqO77p
 hIpenllo1DjNrT1LPFADq7ScfUzjx2hr2szR2bXGZ7AQP0KbYSgx7OPPrgIPSVZ6bouWkH8qm
 dyvP4AA1eqRBidWMFkaQvPy0/N/k/WvrIDnaOPQzoxmh9Fy+Q+xTaYQGsuzHI7+Jmcgbn6GMm
 mCKGM8H//26J9gn721uSyKxIif3BDYMrb6zwDW+Zc0TmAaMZ9n3F2ozFR4m5TEdUGzBbwYVoG
 BZKWDPyJ/CbvuN4ssi8DGh0Q/DdAnZD21guF8N/4p2cXplNPd3l8z0xebZUmb9GJVPk93AL0F
 ZLMAl85zJa3Sy15yWOtQkY47s5OR4pomL1IiAzrY9x3DTtNaD0hst96v2BhLIs/Vks/WUXsIZ
 MoaZqkddr9FjJzjL/KQV2ysu3kK5e+WzGUGdwRQTb9RYGE4z4hDnScnOabIxTuXcTIGJG0ZeO
 oeBWko323W5Gjn2AvmIZK56tWP+bki/NVB4B/8kTME8SDxzAzlwb8oWlfuN8=
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

