Return-Path: <ceph-devel+bounces-2633-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D19A27CB7
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 21:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10EDB3A3731
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2025 20:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4999E219A8C;
	Tue,  4 Feb 2025 20:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mWAnCFiB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E9218E8B;
	Tue,  4 Feb 2025 20:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738700661; cv=none; b=SxrC4d+XfBcYWmi0zA6qfgyNKc52NI/vPIIeJD5lswuB2sdcBBp9O8JZMBfeqsUvjoUQtp0dRxbe63s3tmGn++zfamtZ2DS9mSJnL81EQ7om1wlsEPMtnKYLV/RX3i4bH1URRPKaaHrZi7m7IsFAvzhJMSfegSdkwmhl6ppDqFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738700661; c=relaxed/simple;
	bh=75Sg6DJ0wuEgO5Nk9sCKBkm6E1RJzb3mKvvXTGVIBz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sTQcAv26t9gkx9WRx9Kx2BB+Q3VWQS9Z0I//HY1G6k1+5LGWKcLZV+GpxBbekOrnXEzTzv9nx7g9pWz5bjEIPpXFeGPlZX1eKcn9JxlLxN08vu3Z52eiDfe2VHFrefF2N6FzI3J7LzSNQxH2cErc3UHu8ZeUArPbeuhwAZOmlI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mWAnCFiB; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738700647; x=1739305447; i=markus.elfring@web.de;
	bh=75Sg6DJ0wuEgO5Nk9sCKBkm6E1RJzb3mKvvXTGVIBz4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=mWAnCFiBTGBHF0D8y22X/ofl161UVgRE/LZ4UAbz6KH++7JYgdAOxQiXpGChxE71
	 lTwc8apfhCZwGln7iXyX0wplZ3h9fo66V8uSM3Amk6Yl+8LCTGV7ZRQxy/fLrJ0Mi
	 VaDPQhPEbDn4bA3+RWVOdwdQOyxfvE3X0SAqdpGilsakkXZmE97ZAy6PCThXiz73E
	 oM5oPZp1m+St5d7xzecWbF9D6GTySqTDXhzF4uLJkQVlaooq67k9YQ/JInpZGcRbi
	 Yp/mBJlEL1bw5migda02nTksvwAXtTJz1Xq80N0G+A4g9pRY4JaDD0nx18p4xglq5
	 26KWq19O7RbJM3cusw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.16]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N6JxT-1tLuXO1vbd-010G2q; Tue, 04
 Feb 2025 21:24:07 +0100
Message-ID: <a3b1ecdf-0bf0-4053-8bbf-ecaff4e8cb62@web.de>
Date: Tue, 4 Feb 2025 21:24:05 +0100
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [cocci] [v2 1/3] coccinelle: misc: secs_to_jiffies: Patch
 expressions too
To: Easwar Hariharan <eahariha@linux.microsoft.com>, cocci@inria.fr,
 Andrew Morton <akpm@linux-foundation.org>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 Ilya Dryomov <idryomov@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Ricardo Ribalda <ribalda@chromium.org>, Xiubo Li <xiubli@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
References: <20250203-converge-secs-to-jiffies-part-two-v2-0-d7058a01fd0e@linux.microsoft.com>
 <20250203-converge-secs-to-jiffies-part-two-v2-1-d7058a01fd0e@linux.microsoft.com>
 <49533960-e437-4042-951a-0221164bfa3d@web.de>
 <974a03d2-3f3f-4be2-9dba-ece6dca8015e@linux.microsoft.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <974a03d2-3f3f-4be2-9dba-ece6dca8015e@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:bHRRDUYNgzL2w5T+cBWnQvEzsyVC5tGhQ42pj//Hbr4WJXbt5Tx
 NmigUqbqJgStPgfqohv2o83whcM6RPacemDly0/uhpszNzDSw3IAGU2IJTNaWvTkb7j2QJo
 JxDWv833ZoIP8YHiW6/lT+xid70cxmorwByZZo2wrpkzHlXD5CJM6tPQN3DfzRA7YNRkajF
 qIjSyG47cUu91WN+pwj3g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Ygu3d3nBFok=;Vgbi7VkznJIFuieA/BcpmXLJjxL
 ZFgf31MXADDmjwCBZKeq0yl1JBII2u3U2u8Vx8+pbqSy0KklvYP9lcAdklAoqsqwVjtL+JBoV
 +SASzap27bZKSMQsdsr17b/oxdCJhaFdKju02RLOqomK1EDDvoQqx09WuT40V1qGN31AoUjIf
 +ixzbHmKcndbO0Cy34Ij1VrICdux9x+1dWJrBTl8YC61yydkhNHEPgrTV4Yr9IL14OQXhIVlN
 AiwSIdSSdRCtjti1ydmx6G6frq9leAF14IgXBS4D/n03fON+72pfBM2fFQiLGPVXkwJZOvacX
 4e5g7DEFmy+KkO624irI+m1lJ4UhrT72Wongw6ntrbKbfDFwWSWvTYJIx/uQMOyw3+r2DRmZG
 dXwD0b4DbgR3xtpU8fClMj5auwcw+z0XusU0nrMII48inU5+WJ+0v1dYo5yHFq1ISwNL3z5yy
 HaTsFQ+EO3b6vJ9BkLmXHj+YidJHL4NeIU2mRaeBmjXtYFboite/t7iDVp/G5hgIy2h/K+gy6
 7oWBApvDevTxWTDOI7tS3tr1c+wQ77uSinvuZAdkL2YtwBLGsrcTsM9J7w5uVm9h/9PI8/Cyl
 2ma8d7e/lHRIWIqlzvQqmtpZO4nUjjyDRimvv0gCM2QP78zGVg6AnlMK7z1RW/x9r0Y6uFqKN
 kR6geHrfz53EsXgzuOZZgeBwnkU3dFmV8M6CAgPPGhGVdJoFu41sqhbR+2d18AKYVcU8XEDUL
 UnTsN46NB9io18/A0+lcQCPlU92MoBgxz/+GU5n2beuXX/BH9Z3SZukI9y/uowH0fEbby8rTP
 5M9rfmSjiWSnLHPKDXjCl4rq+8hfa0g24Ncp+NdvY6AfkiRSI0BBiyNJH/C/Jxtn0xJxRQTk9
 joL/em4JNuJM6UHv/LUZj1AMJGObMg5WZCbf/SCnu51nl2l9KAMvlE3fmbcwh3UlwspxjFgnf
 PMWmzNcyIp0HwWZSAWJklv39m+6iIm0PTWTErE6UdKntbCxOMDGUKyoAaEmE2P5jsYYGGpxaT
 lHIj40GfUwp2MnRbGyr+BJhd5jksqq9ai3ZNmpk6mHRiE99M+FSyJj0YtSaL8tgIWq4D8s50t
 dUZW1+ancQnbHj9uHdSGdexcqttgE0q1QGWlXqMmHqikYNdtHILvdaDhAAprPlMQ9MzZ5wDga
 y8OKxkI+12l48PRYLPfVXq9CP8FXicrc5GLs6DggMrK+yWaWRi29kgxLsu24e5K63NQlJvXsY
 iUsjmMiH0ES7wdQj5ylD501ectD1omCsyr1fj6JMBUZpCQmDKOOtDLH+S9GA9P4gZr8j65hmz
 EQGlolNigaM6VSGebRHE5FjOOKDkn6PlIlXVo9A85Wcn31BVr1x7LZpbNYplTMD4u5x

>> How do you imagine that the shown SmPL code fits ever to patch reviews?
>
> By the simple fact of accomplishing the same result despite differences =
in
> code style, as explicitly called out in the changelog.
Do any other contributors care more for the mentioned software development=
 concerns?

How do you think about helping to improve affected implementation details?

Regards,
Markus

