Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7604EAB404
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2019 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbfIFI2x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Sep 2019 04:28:53 -0400
Received: from www1.m-privacy.de ([85.214.254.135]:42312 "EHLO
        www1.m-privacy.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730392AbfIFI2w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Sep 2019 04:28:52 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Sep 2019 04:28:52 EDT
Received: from localhost (localhost [127.0.0.1])
        by www1.m-privacy.de (Postfix) with ESMTP id D3B3924009E;
        Fri,  6 Sep 2019 10:23:10 +0200 (CEST)
Received: from www1.m-privacy.de ([127.0.0.1])
 by localhost (www1.m-privacy.de [127.0.0.1]) (maiad, port 10024) with ESMTP
 id 14165-04; Fri,  6 Sep 2019 10:22:53 +0200 (CEST)
Received: from gw.compuniverse.de (x4d009cd9.dyn.telefonica.de [77.0.156.217])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "gw.compuniverse.de", Issuer "gw.compuniverse.de" (not verified))
        by www1.m-privacy.de (Postfix) with ESMTPSA id 43FB7240046;
        Fri,  6 Sep 2019 10:22:53 +0200 (CEST)
Received: from [192.168.201.30] (tgham.compuniverse.de [192.168.201.30])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gw.compuniverse.de (Postfix) with ESMTPS id 9892380DE6;
        Fri,  6 Sep 2019 10:22:52 +0200 (CEST)
Subject: Re: ceph-volume lvm activate --all broken in 14.2.3
To:     Alfredo Deza <adeza@redhat.com>,
        Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Paul Emmerich <paul.emmerich@croit.io>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
References: <CAD9yTbH74a+i5viVjV6Qj4yB9dguxO946YkUDf6ODQb-wvJM=Q@mail.gmail.com>
 <CAC-Np1xhZoKqVVjMhCPnBoJ5Z0aPj6iL4UYJfgp7M+VXCs9vkA@mail.gmail.com>
 <CALi_L4-rkKonTLAcBK==qs4Cr190j00cbRCDOGWsBWy61RdwMQ@mail.gmail.com>
 <CAC-Np1zv8oHtGj_0L4gWa23KTf3tOnAs_JtTqhZYDvKzNinUpQ@mail.gmail.com>
 <CAC-Np1w45EGTW07ovfrK_sWNg5JNuMkwbs7kxcfBxr=98n6xsQ@mail.gmail.com>
From:   Amon Ott <a.ott@m-privacy.de>
Openpgp: preference=signencrypt
Autocrypt: addr=a.ott@m-privacy.de; prefer-encrypt=mutual; keydata=
 mQGiBD6H33QRBADWO8YVocKtw3/vXs0lwlq2VVdubrEhGuMnnqv3EluyAgYk0ttvaAPuhm76
 o7ZO0SKSiblzoCIvyO1q79Qkfi04TVuAOQ5tSK3JQD4F6kXb0JlmJ9xy9CHamSKG2oM1mKD6
 YY9qsx8FpOklGImRtK/PPd8riDyqXXHnoBMWqELPGwCgto5SV+VKDl7z0e+p9y4xiHyDuYkD
 /iL4sfy4DGqIMPEfRvFn+qKfPmiqH7z8vPcPlY86Pf/6vKZ2A2XOy9tyXa1685TbJr34q4eY
 htFPLY7Bfry9n3yj2cFjgQVWfuumvXE2cn8pYsep9RhlPteDsfC+LOCagz4wP+ak2tlocdJ1
 r0/V4VwiCLyiquD/3GbdaoYe9FAfA/4omG6G4YVsoGvrZ9o94ozbryVigsdk/OHqQ3zo/Od2
 B8/zkdi0ZSr4hafIuEm9oYnnxAvVeelo+JBQQPfZg8/gpW3DR5kmeK9iIJC0i1UbcLb9rg7c
 WIO39y33fEbqqFyb25Z0A8YTJJJx0V8paMpVunCH9Lu55BfdNWa0tDJizLQuQW1vbiBPdHQg
 KE0tUHJpdmFjeSBHbWJIKSA8YS5vdHRAbS1wcml2YWN5LmRlPohjBBMRAgAjAhsjBgsJCAcD
 AgQVAggDBBYCAwECHgECF4AFAk5Dla0CGQEACgkQIrFYWkD7qS6z4ACdFjkusoMZpixVYYdm
 78qFe3GQ+XIAn3agt7P9TvyAbUCsUw5zCpeiw+PHuQINBD6H33gQCACmQiZKL0zMJU2woi7W
 ZpEISraaO+/xbydImRHXam0wsLjLyu9rtAFgm841onkxNFQTpXQmYkaWB2hsuMOLmq7OSv1n
 FGJLc+5t833pX1MNcxEuC91A+Y+ji3W+2r2aWSebP0GnVV64WPGwXoDXVKUVAS1vq0l14UnQ
 8l2X3EBXHc5e9PzsswG26+Nz13dNiLNZgUA8tLme4EuV4LtSbwONUbEIbuScf1aDEZuebs93
 txZkS9BZoZbiH5vL0BWbvhJhJTK+m9c/rMkDwd3LSyJkUedaNOcfjDrgFuC8RuDH+OkNOSh2
 wUXGTF3IyGz2BxbKott5WavfE13s4yA73yvTAAMFCACKoM7oR5jY0bGjSTV2ZDUdFUu3xIF0
 nVW+kEGUBoJCcXhlfy7Sjc3lQxYP5Ykyq9J794NjpBQCletvvH2KKu33eHLcJ+48vexgaV58
 nxnK8dSVHZjzbGbln7voxKfDb+DAhdRqPl7+1H2LS65X8V+oSetLxnz0dSe0x+Vh/dOykf+d
 xZsZXWRyS1NeRlPADotGJhsy5P3fPfyfIqcpfVr/XQZJ9OXMR/Tm1YTm4mKVr+jf4LM+/Tdv
 CrZgmvndLD9hpVyIZSXw+fclT6lLV1dl4nTDiK0EpHda+zqH2hXtj7EKtOK4V7Vv6wH7Ul/m
 U7zJMV/nNJDu1RdIWxiNCNe/iEYEGBECAAYFAj6H33gACgkQIrFYWkD7qS40dwCfRQzNca4P
 2ssXR8xyMOX/NBC5lB0An0g7srLTmYXvBaLikk/SM7Qz6NG2
Message-ID: <7104c259-7874-3af7-f2b8-85b6066ec878@m-privacy.de>
Date:   Fri, 6 Sep 2019 10:22:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAC-Np1w45EGTW07ovfrK_sWNg5JNuMkwbs7kxcfBxr=98n6xsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: by Maia Mailguard 1.0.4.1524 (m-privacy) at m-privacy.de
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Am 05.09.19 um 13:56 schrieb Alfredo Deza:
> While we try to fix this, in the meantime the only workaround is not
> to redirect stderr. This is far from ideal if you require redirection,
> but so far is the only workaround to avoid this problem.

This bug also broke our ceph-deploy based installation scripts, even
with a single OSD. I can confirm that the fix you posted makes
ceph-deploy work for us again.

Amon Ott
-- 
Dr. Amon Ott
m-privacy GmbH           Tel: +49 30 24342334
Werner-Voß-Damm 62       Fax: +49 30 99296856
12101 Berlin             http://www.m-privacy.de

Amtsgericht Charlottenburg, HRB 84946

Geschäftsführer:
 Dipl.-Kfm. Holger Maczkowsky,
 Roman Maczkowsky

GnuPG-Key-ID: 0x2DD3A649

