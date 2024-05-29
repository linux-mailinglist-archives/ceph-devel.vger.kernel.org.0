Return-Path: <ceph-devel+bounces-1185-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C69B98D3141
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 10:28:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75A801F26A34
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2024 08:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267AE163A9B;
	Wed, 29 May 2024 08:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqyEaNLJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B403844C7B;
	Wed, 29 May 2024 08:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716971112; cv=none; b=n+5m20ThQCqjlMHugQbJijNheJMbIHS7x1r/dnuVxp6JU/Xz3JRGpSkrcN+wHtIdxPx4Vo9N9m+W7xucB/j9M/kOoQtJcYPg/KNkIZ71f65899qO9ogx+POFbSWYnrn4aJEPZ+jm4UM646pqKSvjuulUFuHj0hFIzMzVAYWalV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716971112; c=relaxed/simple;
	bh=68h8q5F+j4pjKEcxNZSHuDAUqZpgnW57uKiQqJYjvXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ETY2JtjrQtvpfQpSNBTS9q5ZmerXijDq+FDDqLmOF7B2X5J9EI+BlSEZheUIenyy71BW3+Itchs3sKxXrPClV6of3tz2mMUolk4/lyz9kibJnYsJdxqSUJg9Z9+v4W3mBtqpsLRX7DqkUlW/IA06F/KZNDJM8XmZbrzRmILfzN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqyEaNLJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34391C2BD10;
	Wed, 29 May 2024 08:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716971112;
	bh=68h8q5F+j4pjKEcxNZSHuDAUqZpgnW57uKiQqJYjvXk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cqyEaNLJFYd4VgaxK4xOgO1fLB7/V2NkEYcZNMj3ccG2Mzvpp61LRxO5H4wNFOXas
	 9i9P5vApYqzNiVftsPqH6+3ivxqZDbQQpXB9SIohRK0TdnoPp833Z44jgkjFhNZuhY
	 BGPG5IuhLO8Vo39srFS1asTLrRf87QTWOJrOiQEM6H9VY7vVFKAL0M8AaZGrySb+3e
	 wtua7SU6aKnlakSQaBr/SFZqCqkbfJyWm4sHhHK/vx2ZqIcj/ebCP9P4hluFoJ78kb
	 xa2RVmjSw0F9dLWXjsdQcxM1ZvFiEoX8BWzuuviifbIpZoK74eW2DiuDsdsaVYZzqk
	 NPfPYWCoLxCZw==
Message-ID: <1048ffa4-36bb-4d72-9abf-a8e2dfc874c2@kernel.org>
Date: Wed, 29 May 2024 17:25:09 +0900
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/12] sr: convert to the atomic queue limits API
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
 <20240529050507.1392041-11-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240529050507.1392041-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/24 14:04, Christoph Hellwig wrote:
> Assign all queue limits through a local queue_limits variable and
> queue_limits_commit_update so that we can't race updating them from
> multiple places, and free the queue when updating them so that
> in-progress I/O submissions don't see half-updated limits.
> 
> Also use the chance to clean up variable names to standard ones.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research


