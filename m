Return-Path: <ceph-devel+bounces-1179-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAA48D30DD
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 10:19:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F9BC1F28DBC
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 08:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FF3184112;
	Wed, 29 May 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DZK1VERe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0698169AD1;
	Wed, 29 May 2024 08:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716970250; cv=none; b=Avfkz35gieeJ8Ji4ZqUDZIyzDW/GAMqdDdmo0Dl53vWHm5ODdBbiNBAklU8bFKxYSQkEN9OPN1Tn7Tfgm+z6sshtcxXlBPThR19+h4M/FOm29h0wB4C8/MSsd/A/EyEZzxhPcfO2iPvk39Zs/H8dpvSeL9HtjgAYGQ0DY0xHyAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716970250; c=relaxed/simple;
	bh=PgFyg9WLnPMWyhLQvcC3XtuqulgVK5WUqskSxNXqJas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TqCzbyfVcL6nOT5hrthTjkSRWLEc2H4ElZ2BybeMx2I0R6Jz5R8zO86Z+rXuSCu4pQY0gZVfvtBUQXZRSbeHcxwMhIMJ27ltLz+EMY74UnAXS0FIjdRxUVNhoZ1P5vviqYXui3mcZ9wkyo8LzCEkxV8Rctne/JYhP9srEkyXngg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DZK1VERe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485B6C2BD10;
	Wed, 29 May 2024 08:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716970250;
	bh=PgFyg9WLnPMWyhLQvcC3XtuqulgVK5WUqskSxNXqJas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DZK1VEReps9AHETpZWUhqpsG+MI00Z0ABB6+gsyW4Gi/Z5H2wxRpGys0fUV/CkDBi
	 ekm5UCfe5kEy0dcpfusrq9SB9N1ZwavpRU82ufk8JfWE2lzM+/YXbDY2BXVIIMJY0E
	 T5zQzfJHsOYj5o65HP0rDO9kO+0LU/4axtrqsBUXTVh+zCLdt4IzBnkae9F0/64AST
	 gqMNnuwWzByDW5WKf7i4hE7fr6Q5anX+m2We3adJ81nyxudkw5rtlBVLP6JZkCEX3i
	 Pcy2SlsuFxqd5emx5tb3bXdTCobvVRykH3xWoY1UPtWqs2G9X7g/qXHlmyyZj0p92U
	 NdB9TJbaHuhIA==
Message-ID: <868a031d-a6f5-4f89-b0ee-f74f6ab38dbc@kernel.org>
Date: Wed, 29 May 2024 17:10:47 +0900
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] sd: add a sd_disable_discard helper
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
 <20240529050507.1392041-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Add helper to disable discard when it is not supported and use it
> instead of sd_config_discard in the I/O completion handler.  This avoids
> touching more fields than required in the I/O completion handler and
> prepares for converting sd to use the atomic queue limits API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


