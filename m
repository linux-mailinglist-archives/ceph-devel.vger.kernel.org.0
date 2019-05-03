Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872DF12A22
	for <lists+ceph-devel@lfdr.de>; Fri,  3 May 2019 10:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfECIvF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 May 2019 04:51:05 -0400
Received: from se02-out.mail.pcextreme.nl ([185.66.251.201]:50183 "EHLO
        se02-out.mail.pcextreme.nl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725775AbfECIvF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 May 2019 04:51:05 -0400
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 May 2019 04:51:04 EDT
Subject: Re: [ceph-users] RGW Beast frontend and ipv6 options
To:     dang@redhat.com, Abhishek Lekshmanan <abhishek@suse.com>,
        ceph-devel@vger.kernel.org, ceph-users@lists.ceph.com
References: <87a7gdgngp.fsf@suse.com>
 <613006e7-62d9-a03f-f8d7-5a37ef1ffb88@redhat.com>
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
Message-ID: <77b8725e-31d2-98a7-cfdb-86423a92b2b2@42on.com>
Date:   Fri, 3 May 2019 10:22:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <613006e7-62d9-a03f-f8d7-5a37ef1ffb88@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: 2a00:f10:400:2:425:b2ff:fe00:1c1
X-SpamExperts-Domain: out.pcextreme.nl
X-SpamExperts-Username: 2a00:f10:400:2:425:b2ff:fe00:1c1
Authentication-Results: route25.eu; auth=pass smtp.auth=2a00:f10:400:2:425:b2ff:fe00:1c1@out.pcextreme.nl
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.01)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0R4iIUvzjp5U0k+OHPPhRGapSDasLI4SayDByyq9LIhVn2CYvOGeERgJ
 XHJ58bp8QkTNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3KQQCD/9s6o9U82Uv3RVhoJgQ8
 AFgdi6s1b9H9wLG5P9ertgAi69d5VJHvFfCCKA0EEonwgsckOLhKlam4zacsW8r2cfUV4C23taMx
 nOngs9T/gbuP7hnUK8NQdLwsVWKIkzZ9Zx5j61WEKw/4QB25/NxlAyC0l6BPockJsCCcD74RxQ/m
 f1B6X09Mb/MrhhwT/p+/g5a5hk/XwcC6MhiTfXVCPUYJqGS0QPdirfmKbiIUx7MG2wf4WvmVq0gI
 vEpMsXte0CH4ExjoF85tff90A1HUoVwaoyKiseY5we892IYad3lsxkDrjYxAaP1hGz0QyGcCgytU
 Mu2J9HJXA1Uo4Cp11CM3eCKvKtHnXikdiHiywuT1wzkgZxFDaU+erEuXL4QFy0eB/isP83e9uHLE
 BeHTPI/rzJIRbhotX0RECi4MdQOpLMNCaRT4WCfiBVGyqzs6y6cr/ligExdHAv3RmQ2QEetkvH00
 /xmn6oF5z8skuB4fLNdsm49znGEOwW1RyaT+fhnmPmZ+OUuV5BM6eyy5Vo6xOiF9lxkCbdmQZuTA
 KwIj4GtaUajLEG/z22NsqVf4h3lmbetPuFx0q5tClfsb0NLBB9DPHwnXcAeTBmOZQkjfv1lw+wKb
 ac9ba/pFyTf12yEEB4cQqKcYgDxXOD73+m8TsjtF78s6GTcyWK+ZUvs759kNMXIbrCcY1CmKifCy
 EhsVjsPjKQqT2Zw22247WJ0fXRDgIBlIO6BeKSGLBDMrD7q/cJogwbqzsuokv2G0+fRAbj0/cJ6/
 i7nIUdpEGlL2Jo8ZzKG26nhHj7XdQ08i/oo5D2WAef5LRUr/eEZe5QeEvuAclTSblj1uEFpqZueU
 ZrOewu+5wXspHaQNqZzoZdSmHBxophwpDu6gsq3gt/LAFXMA6KP6KQHFM3qO8myZpmlspFk2wAGd
 VxgX+TwnZiUe11aAq4qV4hLRdbZsDGfh3PBrJrvad27Srri4oZcazFPewWUH8eMWyBrxJG7yzcfo
 HGlmY2l6KDJ6fVXSS6oHb4+uKmeCn7d64iuN+G32xrKBw9kR5kO29A+DqBS7IDoW4YOKXJxRkCIV
X-Report-Abuse-To: spam@semaster01.route25.eu
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 5/2/19 4:08 PM, Daniel Gryniewicz wrote:
> Based on past experience with this issue in other projects, I would
> propose this:
> 
> 1. By default (rgw frontends=beast), we should bind to both IPv4 and
> IPv6, if available.
> 
> 2. Just specifying port (rgw frontends=beast port=8000) should apply to
> both IPv4 and IPv6, if available.
> 
> 3. If the user provides endpoint config, we should use only that
> endpoint config.  For example, if they provide only v4 addresses, we
> should only bind to v4.
> 

I agree with these points above. The default should be v4 and v6 as
that's expected nowadays by most admins.

Only if you specify v4 or v6 explicitly it should bind to that family.

Wido

> This should all be independent of the bindv6only setting; that is, we
> should specifically bind our v4 and v6 addresses, and not depend on the
> system to automatically bind v4 when binding v6.
> 
> In the case of 1 or 2, if the system has disabled either v4 or v6, this
> should not be an error, as long as one of the two binds works.  In the
> case of 3, we should error out if any configured endpoint cannot be bound.
> 
> This should allow an orchestrator to confidently install a system,
> knowing what will happen, without needing to know or manipulate the
> bindv6only flag.
> 
> As for what happens if you specify an endpoint and a port, I don't have
> a strong opinion.  I see 2 reasonable possibilites:
> 
> a. Make it an error
> 
> b. Treat a port in this case as an endpoint of 0.0.0.0:port (v4-only)
> 
> Daniel
> 
> On 4/26/19 4:49 AM, Abhishek Lekshmanan wrote:
>>
>> Currently RGW's beast frontend supports ipv6 via the endpoint
>> configurable. The port option will bind to ipv4 _only_.
>>
>> http://docs.ceph.com/docs/master/radosgw/frontends/#options
>>
>> Since many Linux systems may default the sysconfig net.ipv6.bindv6only
>> flag to true, it usually means that specifying a v6 endpoint will bind
>> to both v4 and v6. But this also means that deployment systems must be
>> aware of this while configuring depending on whether both v4 and v6
>> endpoints need to work or not. Specifying both a v4 and v6 endpoint or a
>> port (v4) and endpoint with the same v6 port will currently lead to a
>> failure as the system would've already bound the v6 port to both v4 and
>> v6. This leaves us with a few options.
>>
>> 1. Keep the implicit behaviour as it is, document this, as systems are
>> already aware of sysconfig flags and will expect that at a v6 endpoint
>> will bind to both v4 and v6.
>>
>> 2. Be explicit with endpoints & configuration, Beast itself overrides
>> the socket option to bind both v4 and v6, which means that v6 endpoint
>> will bind to v6 *only* and binding to a v4 will need an explicit
>> specification. (there is a pr in progress for this:
>> https://github.com/ceph/ceph/pull/27270)
>>
>> Any more suggestions on how systems handle this are also welcome.
>>
>> -- 
>> Abhishek
>> _______________________________________________
>> ceph-users mailing list
>> ceph-users@lists.ceph.com
>> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>>
> 
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
