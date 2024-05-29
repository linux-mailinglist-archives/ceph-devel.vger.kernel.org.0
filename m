Return-Path: <ceph-devel+bounces-1187-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E228D3195
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 10:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7E71C23F03
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 08:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679ED16EC01;
	Wed, 29 May 2024 08:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJHg4EaC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0671D15CD50;
	Wed, 29 May 2024 08:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716971449; cv=none; b=hS7zPn2TgbTkQSu4uQD6VB4AkVk2P/iSsm/7fL2rsO8FH8GtesPPaD4/9uQyZHtWwMPFqRN/0SXNYrjQgph5QyQoPt4QnxrF14DNBAQ8AWoT7MVWDnyajsFsu8ycXlySx6TOGSc8GvPhlkx3+vIY2s4mGQWGKfwChkJ/xcQfHt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716971449; c=relaxed/simple;
	bh=okobbeHOzXq6ivMGxWAQOlHqPIeKQZDwNC64vcjjQ6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttb1psFvdBt48tfAV/+MxD420r1IqsYVp2E++NWSk2Ln+kgw5qC/kjV7eExQeSDMGurpiArtwkwF7wUPaifTEhRJskFD0rydhzOTFCSSYaOP3HhkqjmpNvmW1M8P5CY5fzZnscPQdrXW4eT8wV6q/1OzeV1FOPLg1o0ynupNa/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJHg4EaC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC01C2BD10;
	Wed, 29 May 2024 08:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716971448;
	bh=okobbeHOzXq6ivMGxWAQOlHqPIeKQZDwNC64vcjjQ6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oJHg4EaC6VLoBZLA2tkfhAXWRViSHX90IfPOto1y2u0MBzS2lz8peI4cgrhwJmiR6
	 j9IGX6ydtNHZbJidgJPmMLDbdMXz0lQ2SjJFcgOj/ZzOZSBuyzHMbC9X6txlhFCKjq
	 zicWj7/lpaI7DNz0gaj1s72zKODzpr9MW0uRepDVL9LHZlHfiRvRJLXPYCR5+1kuWl
	 1WzRU4j7uDZm8UVS5ixrUgADkNSKzvq4M0wIXGo6299fOfN++X+wdoS1ukfz0V0jSB
	 OymHRmFQtxJAOdroVyR9aNThRLSfqkLHyDmmUaVQP0WnD4PbxrI2HzlwMAzSkKWaIa
	 Mi/WLM+Dn9sPQ==
Message-ID: <cf5628a4-50e5-4397-9633-c00a3df2a2df@kernel.org>
Date: Wed, 29 May 2024 17:30:45 +0900
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] block: add special APIs for run-time disabling of
 discard and friends
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-13-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> A few drivers optimistically try to support discard, write zeroes and
> secure erase and disable the features from the I/O completion handler
> if the hardware can't support them.  This disable can't be done using
> the atomic queue limits API because the I/O completion handlers can't
> take sleeping locks or freezer the queue.  Keep the existing clearing

s/freezer/freeze

> of the relevant field to zero, but replace the old blk_queue_max_*
> APIs with new disable APIs that force the value to 0.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With the typo fixed, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


