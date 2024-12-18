Return-Path: <ceph-devel+bounces-2384-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE349F61EA
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 10:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 272C51894A1A
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2024 09:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488AC1791F4;
	Wed, 18 Dec 2024 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b="kfNRj59Z";
	dkim=permerror (0-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b="GSy8XIPI"
X-Original-To: ceph-devel@vger.kernel.org
Received: from www2.m-privacy.de (www2.m-privacy.de [82.165.179.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09D7156669
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 09:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.165.179.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734514744; cv=none; b=Gka8By061y4w7kfF2/3/gMJKnoUdqbUXRvZ2SMNSiqnYwg5cmliRZFl59mQ7PGpkWZTw/wkpAKbJE5f6naNHnhiiEFuwaz/4xWZQhD/KTQ/qGYliGX+LnIQQsv55UiFQLoDSTDi6CRcxXF/kXrEfGac8hbY4l/sYl1yU2fz7hAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734514744; c=relaxed/simple;
	bh=dncF4OxiWIa3DuNrmhEmQ0Ms5p9l43EEP7GgzwxW+xQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=EtZ+MrsC/iERQO7xPmYDdlU7aeiNH5n/3BoQVLzGIW6szr/9ecElsjUqePRLDIUclYN1JcDJl6aZLrTXvxD7PfS7f5O58Qx4/6h+OAqCRkx3T/FRgwsdctU+QMuCm3SRfr/ahxh8to350rxMRE+SJUv7HjvwZLOWhwiLTXLQPHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=m-privacy.de; spf=pass smtp.mailfrom=m-privacy.de; dkim=pass (2048-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b=kfNRj59Z; dkim=permerror (0-bit key) header.d=m-privacy.de header.i=@m-privacy.de header.b=GSy8XIPI; arc=none smtp.client-ip=82.165.179.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=m-privacy.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m-privacy.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=m-privacy.de;
	s=2022-rsa2048; t=1734514144;
	bh=dncF4OxiWIa3DuNrmhEmQ0Ms5p9l43EEP7GgzwxW+xQ=;
	h=Date:To:From:Subject:From;
	b=kfNRj59ZKeQu5eF+jqT957tbEjoGxoIGEXJQuwf2zxE69m4faq6Ii1tyh6MCTfGME
	 97f8VLN82MnVbDFyMpNw9Mle9tmeGuOEe8FFtDmHgNiQ77KzqeZuztI3JKy8xIUkSM
	 UAReFxzCHglQFca4AtGMF8wXv/qq+FdKNKujZ8Bix043dSxz2P8ISAAmI/rP3Io/SX
	 qImz9E8rpvSjD4HGTs2ULmd1fKDQzrO2fAbX9NffYLGZw2UaNP13lHVYXzCry5raIt
	 aV98bgS83fOnkL4aQiZ7C5smhRgHyx0AoY5P2Yginnc1Xw1biCgFSRtvE2Wh5C5XKi
	 0ZTKRF/05s39Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/simple; d=m-privacy.de;
	s=2022; t=1734514144;
	bh=dncF4OxiWIa3DuNrmhEmQ0Ms5p9l43EEP7GgzwxW+xQ=;
	h=Date:To:From:Subject:From;
	b=GSy8XIPIi012eBt7pw85jBJeNPRNpFNn6+EWWcjLjUDUrEuqdIgWH6TJUE3UN8RwK
	 +AFtHh4ZpDghd45i8ZHAg==
Received: from localhost (localhost [127.0.0.1])
	by www2.m-privacy.de (Postfix) with ESMTP id 63C5CA936C
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 10:29:04 +0100 (CET)
Received: from www2.m-privacy.de ([127.0.0.1])
 by localhost (www2.m-privacy.de [127.0.0.1]) (maiad, port 10024) with ESMTP
 id 16659-09 for <ceph-devel@vger.kernel.org>;
 Wed, 18 Dec 2024 10:29:02 +0100 (CET)
Received: from gw.compuniverse.de (dynamic-077-008-078-162.77.8.pool.telefonica.de [77.8.78.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "gw.compuniverse.de", Issuer "gw.compuniverse.de" (not verified))
	by www2.m-privacy.de (Postfix) with ESMTPSA id CFBE7A936B
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 10:29:02 +0100 (CET)
Received: from [192.168.201.30] (tgham.compuniverse.de [192.168.201.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by gw.compuniverse.de (Postfix) with ESMTPS id 199D66227E
	for <ceph-devel@vger.kernel.org>; Wed, 18 Dec 2024 10:29:02 +0100 (CET)
Message-ID: <84603f88-a5e9-466a-b632-0ba8729c2187@m-privacy.de>
Date: Wed, 18 Dec 2024 10:29:01 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: ceph-devel@vger.kernel.org
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
Subject: Clients failing to respond to capability release with LTS kernel 6.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: by Maia Mailguard 1.0.4.1524 (m-privacy) at m-privacy.de

Hi!

After changing client systems from kernel 5.10 to 6.6 about a year ago, 
we got many of these messages:

Health check failed: 1 clients failing to respond to capability
release (MDS_CLIENT_LATE_RELEASE)

Recent MDS changes provide a workaround that at least avoids going 
read-only, but it can still lead to hanging Ceph requests.

Kernel 6.6.55 brought fixes that seemed to help a bit, this one might be 
relevant:
     ceph: fix cap ref leak via netfs init_request
     commit ccda9910d8490f4fb067131598e4b2e986faa5a0 upstream.

However, with 6.6.58 we still got some of these messages and hanging 
requests. There seem to have been no relevant Ceph fixes after that, so 
we have not dared testing since.

As these clusters are in production use, we switched back to kernel 5.10 
again, which has been working with Ceph without problems for some years. 
All our tests show that this problem is only related to the kernel 
client version, it happens with various Ceph server versions from 10 to 19.

We would appreciate if someone with deeper knowledge of the Ceph kernel 
client could look into this problem again.

In January (after the Xmas break) we could test on affected customer 
systems with any proposed fixes. The new LTS kernel 6.12 would be fine 
for us, too. It does not seem to have any relevant Ceph changes either, 
though.

Thanks for your work!

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


