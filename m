Return-Path: <ceph-devel+bounces-869-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 011CA856A96
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 18:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0A91B275C6
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 16:57:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 715D213848E;
	Thu, 15 Feb 2024 16:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pre7Mcfz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766FC135A78
	for <ceph-devel@vger.kernel.org>; Thu, 15 Feb 2024 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016062; cv=none; b=oTeTYwM1ZQoCu47cq4VWaYU7HTjLYp8RL7o0TA8wMg0vAM5+hodpvQidlgzCq5B32ha6pA6BVtVQNa84jmz4ujjdIkspZV40NXln3VBSOKVY2STkQeVyFIN+PqblFr5jFMDgfCX34nYjgEVf8v5qcPu+BLiH0WByoFbBhonl2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016062; c=relaxed/simple;
	bh=Qz4PPFUkifJGyaRWPKT8EHaiOM/kn2UbDqOefUgZCmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UFOyJ8RVf3Ed22sm3UqoCtcFFphUOtTaUGa8FbTvwzQpO/7dS4RDln3du/3KRNGpwtqO3kYZOtp9dLkh6XgNxXzVPHGYJI45Z3kHS+mmnqXizAJY3s2NCm6LwXa3qQ/DjPwcI1RdGqyC4LNqAMJz19HeTIB5YeMah9H9nj6mScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pre7Mcfz; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6077444cb51so16220907b3.1
        for <ceph-devel@vger.kernel.org>; Thu, 15 Feb 2024 08:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708016059; x=1708620859; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vEQiCmvhKfS0/A0znECfTzFjRTV/dZsqotvM6rEKanU=;
        b=pre7McfzotVVLA5sRjwMy2EQnVCLSkXeRtOFWwJdhon6KseboIF957xeL8jvjEQbuC
         83P48RFGgvSLKtcvW8Faxk/3+hpwiNc2E26f2oM4oWWVgW3yqy3FzsPRqi8rklqZ8il5
         sJIBJmfC476mwH3QuRT2sx6zo8YzUeqiHTOsz+EczCsA++VJX3CWBTFTNfWnLJlK49X+
         vyfS4aEYNO5eYd4NGkBL1YEHDiCJW1LdR4RR/xaWNpFHmvQXIwH0x6bC0wB2Wnu5NgvM
         MXu9+6r6mlPvmIBWs9oNpChgrhT0C0Xmob4klZmQRrjjNdemKJNRieQFabOeTfbbhU/v
         yyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708016059; x=1708620859;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vEQiCmvhKfS0/A0znECfTzFjRTV/dZsqotvM6rEKanU=;
        b=FnCxAkCqX91drJF1Te7ZFzVymItQTAIlAeTRIOtdOx6pidV8dPlzWdTjY+x5OF6w26
         JWxWi2C9mSwstyXn0oY1UTY6asrHtztxby5HZ4G2iISOTAi9Nw83D44hL6WEs1qB0WQp
         mU7sQXCiuls8cyud75RTqOAA5bCAesmLRfEJR/yS+VlO8j318TArGDVeb3g9jaTjM5/j
         KZyD5DylxVitdt+pbfjLfJ+EUpGxjDmtcKDbtMAe6GWhNrmgd2LmkQ8lLAxud19z+6Q/
         3FQg1ib30OSzXT1pj6KH5LaiQy7PWs8326xkW8xx4WpG5XPSSoFiQlAjHYtCRojEd5ps
         PV7w==
X-Forwarded-Encrypted: i=1; AJvYcCVCUqL2y36NBz6qbNss8gzwPHM9sw3HD7LVnR0d3GyyET/bJAOjCYvSxLzewt2tA3BNP+HS25pHWTdCmcNHlC1rUKy1b+I5nu5HVw==
X-Gm-Message-State: AOJu0YyLmRPicBZIxT7KQ+StvD62keF/Osgjg84SIvcrticNY/SbuAjB
	gMUIYFSBD2tbUej9LJsIwI9BqYdF1KH/6Kai06PzSCsUjthtMnvZWwAYBI+iEWRrbVh64g8Z6gW
	MUBVW/F+ovR4sIp//Jyxk5VVXeAQGjOjdNHEBPQ==
X-Google-Smtp-Source: AGHT+IF28WiAUAxb9BXDQ9j656YBYmKEubg2qRwCcoIKEiRoMN+j/rX1+ioqB8yOfGTSrxa8mYZDRwHKLR7BN/dl2kA=
X-Received: by 2002:a81:b717:0:b0:607:c65a:ba02 with SMTP id
 v23-20020a81b717000000b00607c65aba02mr1752372ywh.17.1708016059449; Thu, 15
 Feb 2024 08:54:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-18-hch@lst.de>
 <CAPDyKFqPnC9jwWnoVz+UVJJ_SGYnB4CrB8jmJOSxCnT7AYQrKg@mail.gmail.com> <20240215164942.GA19722@lst.de>
In-Reply-To: <20240215164942.GA19722@lst.de>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 15 Feb 2024 17:53:43 +0100
Message-ID: <CAPDyKFpSNL28sWqNMY9Y2+tP9VMd_Wabnw1hVjQ-g0RfKCUVgQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Justin Sanders <justin@coraid.com>, Denis Efremov <efremov@linux.com>, 
	Josef Bacik <josef@toxicpanda.com>, Geoff Levand <geoff@infradead.org>, 
	Ilya Dryomov <idryomov@gmail.com>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	Jack Wang <jinpu.wang@ionos.com>, Ming Lei <ming.lei@redhat.com>, 
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, linux-block@vger.kernel.org, nbd@other.debian.org, 
	ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Feb 2024 at 17:49, Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Feb 15, 2024 at 05:40:37PM +0100, Ulf Hansson wrote:
> > Looks like $subject patch, patch11 and patch12  have already been
> > queued up as they are cooking linux-next. Normally I prefer to funnel
> > these via my mmc tree, to avoid potential conflicts (mostly for mmc,
> > where more active developments are ongoing).
>
> None of this is in my fresh linux-next pull, which would be rather
> surprising anyway as I've just sent them out and Jens isn't that
> quick to merge unreviewed series :)

Weird. :-)

>
> That being said it depends on prep patches in the block tree and thus
> I'd prefer merging this entire series through that tree.

Okay, in that case, np! Next time, it would be nice to get that
information upfront in a cover-letter or similar.

If not too late, feel free to add my acks on the three patches for mmc
and memstick.

Kind regards
Uffe

