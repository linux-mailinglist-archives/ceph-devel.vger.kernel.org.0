Return-Path: <ceph-devel+bounces-3863-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92623C03037
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Oct 2025 20:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CA373A2717
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Oct 2025 18:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3416034C134;
	Thu, 23 Oct 2025 18:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="pIYhaEOe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBBB34679E;
	Thu, 23 Oct 2025 18:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244440; cv=none; b=kbyC1xfbwCdkb+zTYqXL/N8zazZyyo0Kiwgy4XiTUr06JdXXr6dkPpnvxr9g4A343Coyg9/wb7Y8pZI3jfjmWye6i4uXX/dPIbg6/9BOg20qZrw28EeuCrqfbg6ZNB5twi4ixlDN8xqFWBUB1OE6KbGRji6f/pe6qHk7J4NTb8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244440; c=relaxed/simple;
	bh=WE0GiHXM5wLFmCst3tPXj2iOCj0/6Z0FGnXt6b0lhOU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=I19UPiLqFKiUUrK6NXS0BKcpA25YYRfb1mkidYiIKgpVNTRFmluESnq3UGgCDVtBqjg+fDwydNv5Q9IB0QIphHarH6M7U7CG3zXDf3+BVVU4ohAJw0wQ5jU9oMm4gUSSeGMH51wfZtyaDCFAgOIzRraiTxCDgqXcCWUO12VnRoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=pIYhaEOe; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761244417; x=1761849217; i=markus.elfring@web.de;
	bh=WE0GiHXM5wLFmCst3tPXj2iOCj0/6Z0FGnXt6b0lhOU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=pIYhaEOe9Cnm3+0JxJx5IG1rhqzaXEmXT9Yi1q4E8CoPG/KsMHvvSHti4LQbdLQ/
	 uH/x19FxcTuOUMsm1ZNKpyACwuyZg5TBIYt1kr+BgBBiZlwnxkjjkY1A4DKyXnjjL
	 sHfbIdaJ7EZxqHn0RA2ag7WLuIJs6Je3Ta/gl0R0cXkWt9vipZC9V5TzeX9Q9oL4a
	 VvfffhpMO1rpV2ZRgEmjjLivZiOequ+SBjDeJIqJfsE4x4kHinUQMEeWp/3sL64rH
	 AO/Fb+eo2nq6PcDwCOG+ABdnp9XcENuhzlhsKkvqScLY2Wbox0rfdSqjnDNLdtXYI
	 ECoTUQSEVTTyp9pyUQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.227]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N30dT-1uBcQ01LuH-00tXZ7; Thu, 23
 Oct 2025 20:33:37 +0200
Message-ID: <6205841f-e395-46f4-99dd-769a8bcad880@web.de>
Date: Thu, 23 Oct 2025 20:33:36 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: ethanwu@synology.com
Cc: ethan198912@gmail.com, fstests@vger.kernel.org,
 ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Zorro Lang <zlang@redhat.com>
References: <20251009093129.2437815-1-ethanwu@synology.com>
Subject: Re: [PATCH v3] ceph/006: test snapshot data integrity after punch
 hole operations
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251009093129.2437815-1-ethanwu@synology.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:iy6w6xSGTabOyzaJhvpou2w2xd9/o7w75dM/hfnOJk3NT3cZCHY
 zg3a8TKdmxipjBw68wK84jU/t3A5pV6niRsQioL7eBIk9+UY1wMkEQvoTOkSqZhJ7mmTx4U
 p9DcNyWyCbxN1Ziu24pXA5jEqt+Cqkd0bKmu6uwPTC3oM0lwv2UiQ3O9NFS6dmvTysHkYrl
 +18kARz7B16pTcq8/27fA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:iwgczpjhgnM=;aIeEINGLxcAP9K2sfdMcBHpM1V1
 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
 Mn5Ii8qSDaYjyoez+WqMGX1F7Q=

=E2=80=A6
> Disclaimer: The contents of this e-mail message and any attachments are =
confidential and are intended solely for addressee.

See also once more:
https://subspace.kernel.org/etiquette.html#do-not-include-confidentiality-=
disclaimers


=E2=80=A6
> If you have received this transmission in error, any use, reproduction o=
r dissemination of this transmission is strictly prohibited. If you are no=
t the intended recipient, please immediately notify the sender by reply e-=
mail or phone and delete this message and its attachments, if any.

Do you expect this action to happen more often with your information?

Regards,
Markus

