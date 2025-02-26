Return-Path: <ceph-devel+bounces-2810-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEFBA45811
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2025 09:26:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE0D31628B4
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2025 08:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC18A1E1DE4;
	Wed, 26 Feb 2025 08:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="SIvRvmLn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB88258CC5;
	Wed, 26 Feb 2025 08:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740558386; cv=none; b=Li48OXh53uyyaByunXEV58gmvSNczpAqpVWEKnchvl/zrN9eSvkAzpQN92dPPImzb+yFFNrOoRjyeW0wGZZgJOmRUtsGdPLCP4d/yoTFmoVUIkEeQnv/Mp6FXs/S2Ig5WwQWpw3nLflkECOSgOG0VZclDHfvFLc5gd+uk6dLVds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740558386; c=relaxed/simple;
	bh=njsILLkZkjyzEv/vKowZpeaDQvMRXfnUx5wck86CXdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=qMUPC1xwV7gs3LPaZEHQuOj+Uefn+Paw6YooZZcK5m77ppkM1AIupJ4ZqMi/wKDskP5ilh2G1sFcO4hd1tturMvlZmExwQMBASFdsEr0x11ouB5hfDAAmEeorNsgtCZXthu3ojvZ7ceBh0qEgaeL1iz8Ik2rc542InpxXvJUkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=SIvRvmLn; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1740558375; x=1741163175; i=markus.elfring@web.de;
	bh=JKZ0hhA194JzGtLnAGjE7Tna8UgHB+lZSaCvTNzqLik=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:Cc:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=SIvRvmLn8flUsGl5JcfolgQVFctLE8OIoa7MSA8VqUzJwiwUljIzskLbousNrkq+
	 s6YCNQz7zIL9+lFqI5WSe7vUrJx0Yo77ScqwzShmSwXuPbW+uHdWmsvfkClFpA7rK
	 usGxux+2O3/m/sH2Ol+aALD3UBAn0eLdYMCB/Zmhd8AxelKc6OigP+h1alFew5Dnc
	 gPrustT65hY/Zl11lrJKD1kY3sy1JITGeTQFZwFBRfct+lEaKac+97UB4gEf52sZf
	 Dfbezpt6AbuUfdntRPve72587MBApZwGt5tNaM+4croKEmsOyTmKlyMXy/PZQ37Cl
	 n5TfjKV2NzLDX+X+gA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.43]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MLzn1-1u50kB3RC5-00JCvd; Wed, 26
 Feb 2025 09:26:14 +0100
Message-ID: <3abf9e69-77bc-40eb-b84e-a84726c693a4@web.de>
Date: Wed, 26 Feb 2025 09:26:02 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [PATCH v3 01/16] coccinelle: misc: secs_to_jiffies: Patch
 expressions too
To: Easwar Hariharan <eahariha@linux.microsoft.com>, cocci@inria.fr,
 Andrew Morton <akpm@linux-foundation.org>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Ricardo Ribalda <ribalda@chromium.org>, Xiubo Li <xiubli@redhat.com>
References: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com>
 <20250225-converge-secs-to-jiffies-part-two-v3-1-a43967e36c88@linux.microsoft.com>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250225-converge-secs-to-jiffies-part-two-v3-1-a43967e36c88@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8T0doJfXh5Xn7cF2aNYOOKjzaCLuQ6TqMSMuzhfQJClOkTbtxxb
 WwwOPp7N2qlsBqQ00o23C3N3aVcUZY4TjAGA+UrRfMjxNPTKTdOiNBOQwZ9VQNsUmd6mbZy
 KL9u5kffTfvv716Cs7afT5khYDw06LMDjCV3+bzJsgWJ4vukB2wup+YsixbEw0HAWd2IhUU
 sgp5ksKAElGs1EpqGW8jA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OGs6+r90pjI=;Xp1eJI63N70NI9WqtvgfsrbPcjm
 rejW+UAjPV4MCQgv3/dxOZAaJVFE+L7EourFK4xAa//fhfqZ0btf2C18nTt3onMh/ij/Yb9Eb
 T0H359kFvwQMR64ul87fexPZIwayUvLL4EMgSbNeZ4Bo99udJSEfTvfapfE8PfdgejwtYtkGC
 vBgpCoA3d3unI7qRXRh9YVLc8njdbqop93SzJzAXXuvQkY0pr2isUFQYfceEEqHyZYUkasX/9
 hjnd9clqawcls/NWlpBzXvnXAdgWWjHcE4IMujQQ/PpeLAbn3IsfKZgbpv6eiTGG+Z7fqQqsZ
 dIR+iTAi+3sMw+MjNa0C/apJS83+HJ+uAVk+cEpMJCm8tp/OGvqnfUVvP4kbrGnEN5pjijKkq
 IuTDQ3D1VHOXo8aXYnRji0Z3C4oY7e1YAEwjE5PWdfkcCNxS7t6u87myzzJfNEsmWEs9jMW2+
 H0rnQaffodiEOSgUHrwEbtuLlWq4GpxSOc6Q/ZlC1jMNPSut2vd3xZ+dtmQv1Nl488cpPmwsS
 JKXdlIqpS/Uh+8ESz1Yl6L5lUJAqnFvBfMa65+cs1cjTgeHKmVDHZ8g0uMWqjjnwmcaWeGLrb
 icCBUjV9O5/YLaNVaiKyHShsLusR+U8qRmV4wk8XR7ZYZj5OeB1vpgawSCQfNexSQRRJsOXXJ
 I2QXL4g/1jt1QlapifmgrxUa6CaIzPZWYYBAm2hdaWdRzA+oSysm37nVGM2HwP+yrvthOwDo/
 5nfI0R6Tp9iaevpPpq92IfJpBCmdKka/vd3uhPaera4sRHUu+SkehtOOc+kzWtp9JMB2bmJ08
 uneEpTPQTfnJijuPS8zw91Fp41AUNHad7+GYTKS8oi7ZilDK9MgcmZDqh2yEJn8LtqKnkqY0V
 b4FrlZkeeBIJ+ZoMrM9VligtBsZQrWT/hSFTPgKF4RnMWr/xsEbIjyr7VnuDQ6W6mc/KqkvMR
 T/Z1p7RMnlXqMVMdEG/RUPfCbNqkA37xnqclEC99lb2otbZ6V5hBEsFVSIF2u4RS0wTottnz1
 ebZ4KPntTuP1H8yR8EXRi43bm0/vIb3H52E9qW0y8ZBngoivBNQ0LwyHIq2aGZ++SHVHolGOJ
 juiTRD1tRMxCHnAA8RpZVJ51z8mhkoCut4QkOKTIsG5g6DPDxGr7uIpfJIuzwFY3TBmWI4bA4
 TQ1OGIFfyt9jpEYH7mNoq2q9TF9CZly0rFAUedyRYm5LpBSHPwp6TGCjI1WAe8yJ6pbSvJoa6
 56jQAESh71iph7QxwpzQKoasaQuoeRBkQeCxh9NnE3lsHLTMCcuw3u7tn/F6wHdFCdoLcOyU3
 vnEpf/g3ha4eTjBE/N6jOgPnPN6P+USvCp0rn9Mb5kdujiLqyNfr1MmGc4W9EtG+aONjj5kGG
 pjlaod0Xin9HArUw2MYbXOw+oJWHaP1O6KCEzJV5TC9zhidAR4gDh4NUGv+eU8QBzOLaYpBOE
 0S9XESzAIgZgr0noSVz8XSbEay1E=

> Teach the script to suggest conversions for timeout patterns where the
> arguments to msecs_to_jiffies() are expressions as well.
=E2=80=A6
> ---
>  scripts/coccinelle/misc/secs_to_jiffies.cocci | 10 ++++++++++
=E2=80=A6

Will any information from previous patch review approaches trigger more de=
sirable effects
also for such an SmPL script?

Regards,
Markus

