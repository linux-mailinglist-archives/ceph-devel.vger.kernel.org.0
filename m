Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7B67298E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 10:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGXIKE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 04:10:04 -0400
Received: from se10.route25.eu ([185.107.213.52]:57912 "EHLO se10.route25.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfGXIKE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 04:10:04 -0400
X-Greylist: delayed 2664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2019 04:10:03 EDT
Subject: Re: [ceph-users] pools limit
To:     M Ranga Swami Reddy <swamireddy@gmail.com>,
        Paul Emmerich <paul.emmerich@croit.io>
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <CANA9Uk6ZyYY1HuFXEjvs4aT3zaf7YvDdCH20Rhgb_5U89em0MQ@mail.gmail.com>
 <CAD9yTbHdKtre8ZjnXTxV_=mE513djznyFP-dgiG+9MpQZxx_Pg@mail.gmail.com>
 <CANA9Uk4Yt9oS7D31oR++f48ph8_KLAXH5ebeSeJAXUvyuF_NRQ@mail.gmail.com>
From:   Wido den Hollander <wido@42on.com>
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
Message-ID: <445eb2fe-4082-8c20-0848-2571f1ec3816@42on.com>
Date:   Wed, 24 Jul 2019 09:25:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANA9Uk4Yt9oS7D31oR++f48ph8_KLAXH5ebeSeJAXUvyuF_NRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: 185.87.184.57
X-SpamExperts-Domain: out.pcextreme.nl
X-SpamExperts-Username: 185.87.184.57
Authentication-Results: route25.eu; auth=pass smtp.auth=185.87.184.57@out.pcextreme.nl
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.06)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0STiPCilqAig5bem4hJMKBmpSDasLI4SayDByyq9LIhVaKOhRJ02ZyMW
 f42b56i7bETNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3KYeHyXmEzPAN+YDQgGWsSeUna
 zdMucQ0l/MpJRCviGtqbrO/5JeJQQ2c40A8s09XxRqtpQqrQeDA0KwfM5rgalPCzKLwT98rZklbH
 qobvrFVMBV+c97vZR3parUa7U8DOzcnIJmV/EOrG3jtoSDbBLR5e973vehgRRMJdd1x498TYr8Ra
 VAHW6tLGcTnh4vahGZLIHyBgucWCg+Uk0L+ZsdYuXBS2clI2zHgPVp9R+HG5782OUII+oTdo0aIn
 Qpq0HuyQo19vpC1U1Pw1dldzqGGrrSMfS8ePNDQgA/x4I815XbOI7YFujQ0UVs6hB+fmnXQrmhss
 wM4hISBumkxR0YtmzhcQd9B0nExZA2UgkeK3UDNUeY3/UJrq9ht6Ao32kO0xel3jsmS7K+L0X9vl
 eny1qHI01YiMvkjV+Ib3Lxl38B2VLS1CpJIOW6O9dEv0FdiB1wGsIwp1rfFVK4orKL/MkTXVmMpA
 WIpXwTCeSh04PkIuTFvjl4kMMVd9vMiFRHJueFlqjP327GuInJjLP/1GLZIAvsr3sDHzA2GMniGO
 UaCLF46jsGXYGJEtOeBZ++DuIQUs/5JJj4C/n4CILsb6+vU3yDsFzuVBA8Mwm8j4eRdjM65dLGEJ
 20IyD0ctI5k6fkB5UW+fF8iABBOlapd7/V3RJl1jWFHiAL9S1hTMe1i8FUFGkyavXfG39Pzfy3F4
 5i5kxp0GsqAuSWupHPdjzQ6YC7Heg3Xf7O1TOd4THdOcqS97vOslVYuZ8k3KQbXy8rEWC9pggV27
 Z41lJYlD9ZLurOs1NTX/ybu7OFrFHnS9+HZQyi0xzbOIP+o9XcEObgAeXh0ac70JoNe6uIKjfL/g
 G0y8QE4XjRpYwLtM8jeeJSytG/Wf88r2kBubXot94oMGgqyFp7hX/MsX0L7aPBgK1CL++zLDgef8
 iJvhmQu9zjuPTBIQ+eJnO1JYMMQrbXgpYquub9AstiyqTzRLsO/VDQ8jTIAIc4tqCQmWpzHMjp5b
 my4v0KrmJ1EX3eSWpIZTb8iuOh1P4svQ5g==
X-Report-Abuse-To: spam@semaster01.route25.eu
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 7/16/19 6:53 PM, M Ranga Swami Reddy wrote:
> Thanks for your reply..
> Here, new pool creations and pg auto scale may cause rebalance..which
> impact the ceph cluster performance..
> 
> Please share name space detail like how to use etc
> 

Would it be RBD, Rados, CephFS? What would you be using on top of Ceph?

Wido

> 
> 
> On Tue, 16 Jul, 2019, 9:30 PM Paul Emmerich, <paul.emmerich@croit.io
> <mailto:paul.emmerich@croit.io>> wrote:
> 
>     100+ pools work fine if you can get the PG count right (auto-scaler
>     helps, there are some options that you'll need to tune for small-ish
>     pools).
> 
>     But it's not a "nice" setup. Have you considered using namespaces
>     instead?
> 
> 
>     Paul
> 
>     -- 
>     Paul Emmerich
> 
>     Looking for help with your Ceph cluster? Contact us at https://croit.io
> 
>     croit GmbH
>     Freseniusstr. 31h
>     81247 München
>     www.croit.io <http://www.croit.io>
>     Tel: +49 89 1896585 90
> 
> 
>     On Tue, Jul 16, 2019 at 4:17 PM M Ranga Swami Reddy
>     <swamireddy@gmail.com <mailto:swamireddy@gmail.com>> wrote:
> 
>         Hello - I have created 10 nodes ceph cluster with 14.x version.
>         Can you please confirm below:
> 
>         Q1 - Can I create 100+ pool (or more) on the cluster? (the
>         reason is - creating a pool per project). Any limitation on pool
>         creation?
> 
>         Q2 - In the above pool - I use 128 PG-NUM - to start with and
>         enable autoscale for PG_NUM, so that based on the data in the
>         pool, PG_NUM will increase by ceph itself.
> 
>         Let me know if any limitations for the above and any fore see issue?
> 
>         Thanks
>         Swami
>         _______________________________________________
>         ceph-users mailing list
>         ceph-users@lists.ceph.com <mailto:ceph-users@lists.ceph.com>
>         http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
> 
> 
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
> 
