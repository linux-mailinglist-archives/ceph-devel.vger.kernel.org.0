Return-Path: <ceph-devel+bounces-1896-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E211499B515
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 15:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22BB1282F21
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 13:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BC71552FD;
	Sat, 12 Oct 2024 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ip2BEU2e"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A44B1E511;
	Sat, 12 Oct 2024 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728739947; cv=none; b=tuOkvOMY7BhTUY8dEJfXSdfKadlozvwAeW5yKeDmqBLn7yythEpuU6s2qi/vZtziUxAeJObk1peUYzTxrlL/ucFY10J4mISypg/HulMu4188AZEcsQ+SOSY2O9V6/RLv0Xl7o91oLlgQ2WIvwEG2vuZQlXfshnXDkKX0AcozRhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728739947; c=relaxed/simple;
	bh=ErfgIXpg0kmmQliqjIJ9x+PjCVeG1Kt2llT8QPiOrDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSjvNV6iwp5MKnNWlaGv8LqyB+OnkgkJneCCpMDa9WzPxf2XNcpIMXLh6c+7oA34Ci31KXYcRP6OIQffVzYmzkbcx+bnEpOqGbBF+LHrLGs+s8aONI/FqEk3Vb/+rFK4WAS149dUn1EE+sv3dtz9klP5ssK+nGl3M0C7Fs2ZzTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ip2BEU2e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4256FC4CEC6;
	Sat, 12 Oct 2024 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728739946;
	bh=ErfgIXpg0kmmQliqjIJ9x+PjCVeG1Kt2llT8QPiOrDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ip2BEU2em4OhRbedLAxfU8pQylGTzkUdG2AumboUSnP2EQQflbb8TLLHJau4z6zQU
	 p1iH33qMh3sw1aTUrjKAwlgc/252YlQIaRUSKIGdsBDLVC/g/pGVQGONR5QqsY7iLU
	 j8fsRxPh2RmFw7kA9W6Ap6X0FN4Iq/ZsIbo9ngKIJorfGvONEda7OAViqnzRHFStaX
	 +bZRk7ACdz4uIZ0aDlUC6wzZ9aHSrY0e53XWIEObfOaxrlLr+EzLA6I++mHR/S7Bpc
	 8wWnaWYZSqgZkgCnkuQrS4XZtouRBthqMGLlkbfmYHw4xS7KgeojOTGLoaWqDVhDaB
	 hYa6xy+TNgaBQ==
Date: Sat, 12 Oct 2024 14:32:23 +0100
From: Simon Horman <horms@kernel.org>
To: linux@treblig.org
Cc: idryomov@gmail.com, xiubli@redhat.com, ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libceph: Remove crush deadcode
Message-ID: <20241012133223.GJ77519@kernel.org>
References: <20241011224736.236863-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011224736.236863-1-linux@treblig.org>

On Fri, Oct 11, 2024 at 11:47:36PM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> crush_bucket_alg_name(), crush_get_bucket_item_weight(), crush_hash32(),
> and crush_hash32_5() were added by commit
> 5ecc0a0f8128 ("ceph: CRUSH mapping algorithm")
> in 2009 but never used.
> 
> crush_hash_name() was added a little later by commit
> fb690390e305 ("ceph: make CRUSH hash function a bucket property")
> and also not used.
> 
> Remove them.
> 
> They called a couple of static functions crush_hash32_rjenkins1()
> and crush_hash32_rjenkins1_5() which are now unused.
> 
> Also remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Simon Horman <horms@kernel.org>


