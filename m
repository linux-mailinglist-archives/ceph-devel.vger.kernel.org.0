Return-Path: <ceph-devel+bounces-2393-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5299F6EF0
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 21:33:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A6241889A84
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 20:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99AF166F32;
	Wed, 18 Dec 2024 20:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b="AmVse/LT";
	dkim=permerror (0-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b="nEeceChs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from www2.m-privacy.de (www2.m-privacy.de [82.165.179.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B179154BF5
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 20:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.165.179.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734554017; cv=none; b=jaQGBTXt2dDx1gF5bgCBtofTV3KYW+SkodUHsO5I+M+C9VcG9Y3U42jLIpZvACotjasb7iilXo0ZDhTku6EH3uYNzf1S2mwc2fLxix4UJRtXwnz0TEr/NgBCxgylqurN3CvgkUASIm7zsxik4CcgKg7tP1CZj/zHLrZ76oMhue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734554017; c=relaxed/simple;
	bh=Tfd9Kp48bEvUN5Zr3Ob+WhaAQPbOzdSzuTEf6242klc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=pg/2y6E3LQiaGCSDCvBEgOSlM1SSfSxWuUlY2HzLCOf600H3ZLvApPm2RqRRKDukfjO45W5UnV3DMMsMjGVa8tfYrc7mV0nEPgyjrjycHlYgODR0wjmEVKfv9h6ACSJ6Ma0q8lvOT2MavizLH3O64Wyl0hGdRNYEVz5NZNJFMFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=m-privacy.de; spf=pass smtp.mailfrom=m-privacy.de; dkim=pass (2048-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b=AmVse/LT; dkim=permerror (0-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b=nEeceChs; arc=none smtp.client-ip=82.165.179.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=m-privacy.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m-privacy.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=m-privacy.de;
	s=2022-rsa2048; t=1734554013;
	bh=Tfd9Kp48bEvUN5Zr3Ob+WhaAQPbOzdSzuTEf6242klc=;
	h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
	b=AmVse/LTiQlaeKMIYfFMC5p/nHu5CN8B999SV/T6DY3afOuxSQaPAJWwMTnYgkwWz
	 4E3NQ0J2+YjwEa2XXSozrIipN0oxqg9cxui7ICxJpWg4V3uWv38VbaA4SfJzPYnfPj
	 YU0gV+pEYFINY7pvC1uXiwOq8weCC5Y1JmP9V2kxmj4jkQ40tMmusM0g05Ae1BFYwv
	 jYE2fK8RPXaIRJmSN/xE+Cq0B1HtAjBmp23DcP6Buiualcz/FqdU6esgWD8O/KOo30
	 Zo0IGMFgU1vbDbKwIbjgoxaRr+dwMIwox1IKMEXEUc6RQfkO6jr5CYp8FaXPNhiuoj
	 YHrhL/esbkD5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/simple; d=m-privacy.de;
	s=2022; t=1734554013;
	bh=Tfd9Kp48bEvUN5Zr3Ob+WhaAQPbOzdSzuTEf6242klc=;
	h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
	b=nEeceChsH/LRq9vCvwVVrxgw/Lbo/a9A7trPw9WBEritTXMdWE0MDHitP7KD8yvU1
	 OGVo+fl81kb33KhTMabAw==
Received: from localhost (localhost [127.0.0.1])
	by www2.m-privacy.de (Postfix) with ESMTP id 1A29DA9034;
	Wed, 18 Dec 2024 21:33:33 +0100 (CET)
Received: from www2.m-privacy.de ([127.0.0.1])
 by localhost (www2.m-privacy.de [127.0.0.1]) (maiad, port 10024) with ESMTP
 id 03503-07; Wed, 18 Dec 2024 21:33:31 +0100 (CET)
Received: from gw.compuniverse.de (dynamic-077-008-078-162.77.8.pool.telefonica.de [77.8.78.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "gw.compuniverse.de", Issuer "gw.compuniverse.de" (not verified))
	by www2.m-privacy.de (Postfix) with ESMTPSA id 6C834A9032;
	Wed, 18 Dec 2024 21:33:31 +0100 (CET)
Received: from [192.168.201.30] (tgham.compuniverse.de [192.168.201.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by gw.compuniverse.de (Postfix) with ESMTPS id C23B76227E;
	Wed, 18 Dec 2024 21:33:30 +0100 (CET)
Message-ID: <dd985beb-7ce5-42a2-9781-ae9a9c9c32b8@m-privacy.de>
Date: Wed, 18 Dec 2024 21:33:30 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org
References: <84603f88-a5e9-466a-b632-0ba8729c2187@m-privacy.de>
 <CAO8a2SgpMBW0pXZGUdmATLJMhKB39xWLoa8+T_ovLmipAW8VEw@mail.gmail.com>
Content-Language: en-US
From: Amon Ott <a.ott@m-privacy.de>
Autocrypt: addr=a.ott@m-privacy.de; keydata=
 xsDiBD6H33QRBADWO8YVocKtw3/vXs0lwlq2VVdubrEhGuMnnqv3EluyAgYk0ttvaAPuhm76
 o7ZO0SKSiblzoCIvyO1q79Qkfi04TVuAOQ5tSK3JQD4F6kXb0JlmJ9xy9CHamSKG2oM1mKD6
 YY9qsx8FpOklGImRtK/PPd8riDyqXXHnoBMWqELPGwCgto5SV+VKDl7z0e+p9y4xiHyDuYkD
 /iL4sfy4DGqIMPEfRvFn+qKfPmiqH7z8vPcPlY86Pf/6vKZ2A2XOy9tyXa1685TbJr34q4eY
 htFPLY7Bfry9n3yj2cFjgQVWfuumvXE2cn8pYsep9RhlPteDsfC+LOCagz4wP+ak2tlocdJ1
 r0/V4VwiCLyiquD/3GbdaoYe9FAfA/4omG6G4YVsoGvrZ9o94ozbryVigsdk/OHqQ3zo/Od2
 B8/zkdi0ZSr4hafIuEm9oYnnxAvVeelo+JBQQPfZg8/gpW3DR5kmeK9iIJC0i1UbcLb9rg7c
 WIO39y33fEbqqFyb25Z0A8YTJJJx0V8paMpVunCH9Lu55BfdNWa0tDJizM0uQW1vbiBPdHQg
 KE0tUHJpdmFjeSBHbWJIKSA8YS5vdHRAbS1wcml2YWN5LmRlPsJjBBMRAgAjAhsjBgsJCAcD
 AgQVAggDBBYCAwECHgECF4AFAk5Dla0CGQEACgkQIrFYWkD7qS6z4ACdFjkusoMZpixVYYdm
 78qFe3GQ+XIAn3agt7P9TvyAbUCsUw5zCpeiw+PHzsFNBD6H33gQCACmQiZKL0zMJU2woi7W
 ZpEISraaO+/xbydImRHXam0wsLjLyu9rtAFgm841onkxNFQTpXQmYkaWB2hsuMOLmq7OSv1n
 FGJLc+5t833pX1MNcxEuC91A+Y+ji3W+2r2aWSebP0GnVV64WPGwXoDXVKUVAS1vq0l14UnQ
 8l2X3EBXHc5e9PzsswG26+Nz13dNiLNZgUA8tLme4EuV4LtSbwONUbEIbuScf1aDEZuebs93
 txZkS9BZoZbiH5vL0BWbvhJhJTK+m9c/rMkDwd3LSyJkUedaNOcfjDrgFuC8RuDH+OkNOSh2
 wUXGTF3IyGz2BxbKott5WavfE13s4yA73yvTAAMFCACKoM7oR5jY0bGjSTV2ZDUdFUu3xIF0
 nVW+kEGUBoJCcXhlfy7Sjc3lQxYP5Ykyq9J794NjpBQCletvvH2KKu33eHLcJ+48vexgaV58
 nxnK8dSVHZjzbGbln7voxKfDb+DAhdRqPl7+1H2LS65X8V+oSetLxnz0dSe0x+Vh/dOykf+d
 xZsZXWRyS1NeRlPADotGJhsy5P3fPfyfIqcpfVr/XQZJ9OXMR/Tm1YTm4mKVr+jf4LM+/Tdv
 CrZgmvndLD9hpVyIZSXw+fclT6lLV1dl4nTDiK0EpHda+zqH2hXtj7EKtOK4V7Vv6wH7Ul/m
 U7zJMV/nNJDu1RdIWxiNCNe/wkYEGBECAAYFAj6H33gACgkQIrFYWkD7qS40dwCgnR6/h5ih
 5vsnmsrCepzPEhA2onsAoKzDw4YB8kEUzkZx7gjeyhnnAw+m
Subject: Re: Clients failing to respond to capability release with LTS kernel
 6.6
In-Reply-To: <CAO8a2SgpMBW0pXZGUdmATLJMhKB39xWLoa8+T_ovLmipAW8VEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: by Maia Mailguard 1.0.4.1524 (m-privacy) at m-privacy.de

Hi Alex,

thanks for your reply! We download official vanilla kernel.org sources 
with git, merge RSBAC and some small things on top and compile our own 
packages. No distro patches involved. The Ceph part has only very small 
RSBAC related changes, I am sure they are not the problem.

Unfortunately, the bug only shows under load in customer clusters. Only 
few of these customers like experiments with production clusters - they 
have no internet access, if the cluster breaks.

This said, I will ask our support people to save any log snippets they 
can get their hands on and pass them over to you.

Regards,

Amon.

Am 18.12.24 um 16:05 schrieb Alex Markuze:
> Hi Amon,
> We are already investigating similar issues, if possible two things
> might be of help to use.
> 1. A recreate test scenario
> 2. A dmesg log if it contains any errors or warnings.
> 
> LTS kernels I assume ubuntu? Knowing the exact kernel version would
> help bisecting and finding what caused the degradation.
> 
> On Wed, Dec 18, 2024 at 11:39 AM Amon Ott <a.ott@m-privacy.de> wrote:
>>
>> Hi!
>>
>> After changing client systems from kernel 5.10 to 6.6 about a year ago,
>> we got many of these messages:
>>
>> Health check failed: 1 clients failing to respond to capability
>> release (MDS_CLIENT_LATE_RELEASE)
>>
>> Recent MDS changes provide a workaround that at least avoids going
>> read-only, but it can still lead to hanging Ceph requests.
>>
>> Kernel 6.6.55 brought fixes that seemed to help a bit, this one might be
>> relevant:
>>       ceph: fix cap ref leak via netfs init_request
>>       commit ccda9910d8490f4fb067131598e4b2e986faa5a0 upstream.
>>
>> However, with 6.6.58 we still got some of these messages and hanging
>> requests. There seem to have been no relevant Ceph fixes after that, so
>> we have not dared testing since.
>>
>> As these clusters are in production use, we switched back to kernel 5.10
>> again, which has been working with Ceph without problems for some years.
>> All our tests show that this problem is only related to the kernel
>> client version, it happens with various Ceph server versions from 10 to 19.
>>
>> We would appreciate if someone with deeper knowledge of the Ceph kernel
>> client could look into this problem again.
>>
>> In January (after the Xmas break) we could test on affected customer
>> systems with any proposed fixes. The new LTS kernel 6.12 would be fine
>> for us, too. It does not seem to have any relevant Ceph changes either,
>> though.
>>
>> Thanks for your work!
> 

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

