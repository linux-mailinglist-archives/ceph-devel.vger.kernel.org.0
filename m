Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7967BBA
	for <lists+ceph-devel@lfdr.de>; Sat, 13 Jul 2019 21:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfGMTBq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 13 Jul 2019 15:01:46 -0400
Received: from se01-out.route25.eu ([185.66.251.200]:47121 "EHLO
        se01-out.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727874AbfGMTBq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 15:01:46 -0400
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jul 2019 15:01:44 EDT
To:     Ceph Development <ceph-devel@vger.kernel.org>
From:   Wido den Hollander <wido@42on.com>
Subject: rados-java 0.5.0 has been released
Openpgp: preference=signencrypt
Autocrypt: addr=wido@42on.com; prefer-encrypt=mutual; keydata=
 xsBNBFPkomgBCADGA8E8Wm2bG2lSTggjk4i6iEHEA6EZJ9Ln2nTIGPg+QbRAZSYuPBtr0d6K
 kijiFzh0oujoQ5Q6UlK1sp3on7PIsmKeK5K54Ji+is28xPaUAoEVteTb/2XuLon/sobO+fzM
 v2nrZ63owjQRMUtuR9vJmZ+aODq0WyHUj4bw1WVIL3PBkQ5QuwDA6u5e/UlugvdVf+GMCFOM
 wOo8mh6IRtYQTqoUkiGydrAM8gFbOTA9rO4bFpbSbiu/e9FbDwdmj370YHFVd6s/wgNtOeKs
 pQVdWD8tJI8eI8g0L/HYfxD69BTnyI0YPjI1n/aDHRvh0F1usYoTXb2/18pDPNcjVfxvABEB
 AAHNO1dpZG8gZGVuIEhvbGxhbmRlciAoUENleHRyZW1lIEIuVi4ga2V5KSA8d2lkb0BwY2V4
 dHJlbWUubmw+wsB4BBMBAgAiBQJT5KJoAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAK
 CRB9xvI4O0zu2g9wB/9l6xuaRF1J3gQB7jAg/B2PnOM4KmjoFPMGSMtKs94rLoqmcn5GUD4H
 JEdSiP5USqh0OnLN6Knb1ZAASWzLOji9QLq+nPI8zjeMXChF2Qf7/qkP75MslH3wBxy16yl2
 0yvd7wqZZXbc7vKSkxVMvJdxqf738d+Zc38u0z0cV43h77T3CvxZuEA13WeHK/eHQCXx3sBl
 zrjfylM0UbIDhntNWe9q5BYtOOQJpfq9t7DQwTQ6m7VFMrFBExP3ZdHIOvFKesrHyGAJLMw+
 8nMeEdWOe9TEsBgmhxny5TJmygNcekuzoaWSknyHn7vwLNSESejs/Vs3/duv/luZWbkpvaq/
 zsBNBFPkomgBCACbkn7d8A2z/4691apLM07NyvkXBON7+HPtBm7LFJ2YnVcfc1AaX6d8XVnG
 s5aKMqaa5+ZVDpvKX0rUE9B8neQQ0UwUaEG8QlSuilBfAbDA1+8NtjIkoo7Vcy0PTJ1kGhgV
 D4cD98SIT+NpCB0Om9D80O14YP+ES9pkL3XEcixPy7LpLVTVMz2ZH1PXZy/pm7AdSHX/xcKG
 SctiO2C8jWq0VZdoQSP5hhnf4FOZdhTnp2bZFFgC/5EQ3tTrBMOJiftmOFf5ai5CLffoBRqN
 8e8wsVohcdRKEDvMtdKJntncG3pmJIuDMSWQxhM1LrZ7UgeSBbrS+vCdyKplXwdDw/GJABEB
 AAHCwF8EGAECAAkFAlPkomgCGwwACgkQfcbyODtM7trA2gf/Ydp28gq6PFZZAycM4n4bUQ2p
 E34E91VBpJZlYGHJWoBbkBgf6eAzkWXZq2sDnnAjxPP9H7RWyPZGH4xRB4U7JdtAD4z46gWT
 8qoWvkbwfZlrmxEPkyTIi05msiNYRk6iGOkb5Oob0yp03ROxZRGljiiLzS44BgK9M+n67DxC
 IlhSiSotHSfljbMUeMj1VXLrmusEw7Dtds5LzON2UZFd/AUJP6zj9GHCpTsvEwacsCdia683
 44jzAsFJLduXHdNa9SKlreahe8fGmv8CAtQpD4OuLiDsqzzwkKPI6GAd1MqJQh5AwM0HarPt
 oDhu3Bo+SVdO5LIKLCmujjBbHZBHIw==
Message-ID: <da5b29d5-4be4-6cb6-c260-c0a5cccaafea@42on.com>
Date:   Sat, 13 Jul 2019 20:28:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: 2a00:f10:400:2:425:b2ff:fe00:1c1
X-SpamExperts-Domain: out.pcextreme.nl
X-SpamExperts-Username: 2a00:f10:400:2:425:b2ff:fe00:1c1
Authentication-Results: route25.eu; auth=pass smtp.auth=2a00:f10:400:2:425:b2ff:fe00:1c1@out.pcextreme.nl
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.15)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0U6y6flTXvu8AHhQTLy0w52pSDasLI4SayDByyq9LIhVUZbR67CQ7/vm
 /hHDJU4RXkTNWdUk1Ol2OGx3IfrIJKywOmJyM1qr8uRnWBrbSAGDTAVfnPe72Ud6Wq1Gu1PAzrsr
 2GHY/oPc/Sj6e6fjMOPgo34CxMJsfFVRRl+N7XQzvcr3Zfx69WQ9D9qeF/TvXEMC83EcGqebH9oT
 x2HeTuIEQSRkwWzD2mSh4NTwjLDCSq2swcqdmOMtvfhrEkAbGxX98uJKifzY3xpJiZsVAXaQVhek
 f4tomG8ezZ3lBknoGZi9JExiFTdw7YTNQfBVcTBDOAfdlSW2SB1UylrOE0M+PB9oHasT9LYGFAGT
 CUrRSAoKui/UZqxZXW+PYL7Slxe4BPzpam1U3Cj9xZx6U4N8tahyNNWIjL5I1fiG9y8ZwNP1kbQK
 ZdzS/i0oexRKO47w4vcwqZanLHsZM8r4s5ZjlHoGly8aneNxj+pRyx6DOD5CLkxb45eJDDFXfbzI
 hV32xBCtyUJ3/LbSt9KpDYeNLtSRWKGmohoil/1AiKo+tkgXyuidojvEg3qjfiiAf/vg7iEFLP+S
 SY+Av5+AiC5WR8iGwBY1KJ7qAHJR+1YmT01pFYpIIFi9UgNlQHB3Y8pPWJnot0587se7BLtPvFq1
 XeLBrYcYJalfgTMPbKrqcgBpDQhLVZmxes5GqKWcApBulS1g9I8ykB+sHWZJB9K4yHHb7u7gww5i
 F3nCyxFU3fE36i0gnrStL1mrPLHgOqCm7NVHprnCF4AvxZB8t6Rr5VekyFH2PxiKUWMGdhUBQ6Uz
 ftoOj4uNELrC733lNxhJ9mxCYKx8Ry2Cil+ihZEOicdxThHJVcNqfJwjtI/gHHASJNUmoOHSoqgq
 xfHmWRq17OupxD/P66B7w+Dkmeov6A2GoMB4xVOP5F2mqXdn5gs4uLvDJioEdCswT4sgCG0AuXq0
 T17woJo3avKeADIPpOpYJ5j2uH0RpwEAtX6IYWJ+VvKzLzqnxavnP4ahhPVMxaTEvkG4ksrS4XAI
 /xZgMfW3dtMUO/t2hIeLElNMMG1QP35nsYfP84c+RFK3KmTSAEVWoBDIY8hi+ZZUOvcZrqpC1wjA
 V/qK1pG17sL3
X-Report-Abuse-To: spam@semaster01.route25.eu
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Just wanted to let everybody know that rados-java [0] 0.5.0 has been
released.

You can download the new version from download.ceph.com's maven repo [1].

A list of changes:

- implement Closeable interface in RdbImage for try-with-resource
- fix JVM crash due-to invalid pointer access
- Realize the function for a snap to roll back

Thanks to everybody who helped!

Wido

P.S.: I need some help to get this into maven central. Anybody who can
help me with this?

[0]: https://github.com/ceph/rados-java
[1]: https://download.ceph.com/maven/
