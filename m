Return-Path: <ceph-devel+bounces-2617-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D5AA23F7A
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 16:13:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 813C27A376A
	for <lists+ceph-devel@lfdr.de>; Fri, 31 Jan 2025 15:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FB111CAA93;
	Fri, 31 Jan 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l94an1pd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C221C1F13
	for <ceph-devel@vger.kernel.org>; Fri, 31 Jan 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738336427; cv=none; b=SgJgFSbql7qy1y1spGNSWx7q3Uu8F6L8dzq2OXbv1YXlJ8aYmA3yL1xf8eKk3/1JiWXLtrjM+w46H7FVMM5bS0UFwUJiv4L1GG8YHyQvniPgqcklsd6PXvPH24/vs4BmNc8Pzib4SChvAWTvgs/OwbbiG4w7gLROgaeIi9KJWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738336427; c=relaxed/simple;
	bh=4gQp82pyQdSv9h4bIaao3v5flWvB/YqaorWgObY4Jfg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZuWi8IpWl1bIbDK3w33TQ3iSmJ6bkkc6aR6vVRe8A8gGjEG1m6Zm0hIdvLRJX18TCaI8bfPFifDuu36HyA3OPIMKt9EQeyAIwZteADWnhVPvXb+pBBY0HQy+/yR7BQgT/Voa1tj63lAYJeUpN0ReMzyteZuFMTAzMK4y7TxOGb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l94an1pd; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844d555491eso58060739f.0
        for <ceph-devel@vger.kernel.org>; Fri, 31 Jan 2025 07:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738336425; x=1738941225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+9HC8EV1wWIoNgKbafn8wjlhkFnTml5y5fJi9ZNauA=;
        b=l94an1pdXrSSUOv+7SXgzHI6LXFtjM6M83K9U55R2DEDk59PYNHWQNPLz5Wk0Ib1V5
         /PzkLns1Q//b9IcukSm11w3f6wZDBXUTjQ1CKOCrIkEUJxxYc3ZQHCnx7+mrlA8p7VzJ
         erA0MuoiHMczPPZD61c7njpIp7f+MSiNMGcMdb0jpLpYxSrpndebzt4JUdh/NVAd9FnI
         ViLcv4t90Hi2DSSyziyLI0hLAD5OqF/pKIeutNqmmJfD3ZHlXeJTy0dSKmcD+7Y5IM+R
         6lKVyTwKgZuB01HbL7rsTJ0ERFQZ0VUCHec/HEBMgL7mbHXJWqYbogp1tyviN3YX3zEE
         fntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738336425; x=1738941225;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+9HC8EV1wWIoNgKbafn8wjlhkFnTml5y5fJi9ZNauA=;
        b=StkyMUCk0hCEiYJYpLRVm47KFb/eQ0DAlnid9HDk9z4CC5UUmfLi8QKePB5djzj24H
         AWBZmWXafrmN6T6J6yUSfee7f2Sl+RdweBRIHk5A3JCmgpLbpkpdeH0YgiVmE09I9VRl
         kFcB6YXn5DXAY4TrRrYCnmjP6/54kN+N4FR/G3D7wHAyJNuBjO5lfq8FwxlmI9xBWp2M
         EuyBvwHD+Z8VYhcWIcoVOZL4u8Zdy5zfC7t9NI2fPWWq/ub/yyiDb2Dest/cCMUzHnFv
         D3RASeovymUTBufGh3JLzVRYcKQhsjqA/uzR432mfcoxbC9yTY6ETNRUC2ps2bRaGyNb
         0s+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXuMU/Q14q/diZbf5NC/SCNnS8U04F8pE9Xsd0JBszwJwej1pryDXildHOWBucYvNr0sDmk0TvQwQie@vger.kernel.org
X-Gm-Message-State: AOJu0YxMUxynhXkiV+TuNTw0pd36ECk7WuV0D5ipLKljY/zsaV8HiSki
	rDZqvpkTE4qxUQrdvon3KuvjPQKD13RQSoEUHdV3xmOO0b1FSnZOHAbALybwX1w=
X-Gm-Gg: ASbGncvHSoTvTYNDmd3cRdlEKGi6AG8wa/nOk1y4h7gIn9xKW90ZehPixunDu0fKoD/
	5attx9a17qnY6BRv/xjEuyRWYpmmML1fM1e9K6srWSff8gXcX+yS2aayPLW8PZZQE4g/yKJBVSw
	2Z3UAvaTZ/QYx4GKeTJKmRwZ4g3bIljJPEavtoRmPcbNYsxen8ht3zwdyMfo1REBTXY9K0U1pB6
	gDYNcR9TFV5u0ExAvLWAS3aY/dDYPyIPDKNN+qG5CisSAGJQ97lFY0HW3o5H1dWQNcLhSvevqE7
	i5vj4g==
X-Google-Smtp-Source: AGHT+IHdBYkV/Lcjpt9Dx2u2hBI2V53NbB2KTd/PWwFq4iCV5vqkwpfG1ZQm3S6I8vweH0IHJRW4Uw==
X-Received: by 2002:a05:6602:6406:b0:843:ea9a:acc4 with SMTP id ca18e2360f4ac-85427e24fa1mr1154985639f.8.1738336424835;
        Fri, 31 Jan 2025 07:13:44 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c920dsm856099173.125.2025.01.31.07.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 07:13:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, 
 nbd@other.debian.org, ceph-devel@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-mtd@lists.infradead.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
In-Reply-To: <20250131120352.1315351-2-hch@lst.de>
References: <20250131120352.1315351-1-hch@lst.de>
 <20250131120352.1315351-2-hch@lst.de>
Subject: Re: [PATCH] block: force noio scope in blk_mq_freeze_queue
Message-Id: <173833642386.354079.3672902422068183900.b4-ty@kernel.dk>
Date: Fri, 31 Jan 2025 08:13:43 -0700
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 31 Jan 2025 13:03:47 +0100, Christoph Hellwig wrote:
> When block drivers or the core block code perform allocations with a
> frozen queue, this could try to recurse into the block device to
> reclaim memory and deadlock.  Thus all allocations done by a process
> that froze a queue need to be done without __GFP_IO and __GFP_FS.
> Instead of tying to track all of them down, force a noio scope as
> part of freezing the queue.
> 
> [...]

Applied, thanks!

[1/1] block: force noio scope in blk_mq_freeze_queue
      commit: 1e1a9cecfab3f22ebef0a976f849c87be8d03c1c

Best regards,
-- 
Jens Axboe




