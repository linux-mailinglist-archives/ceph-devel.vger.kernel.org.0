Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAC33E93DF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Aug 2021 16:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhHKOo7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Aug 2021 10:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232704AbhHKOox (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Aug 2021 10:44:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9081D60C40;
        Wed, 11 Aug 2021 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628693069;
        bh=3WcQIY1Tldw+FnGk13T77mMfYCNCQ3e3KZ22Er7jjZc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dJrJpnPDs4s2BAuAsKuM0rhtBvWG3kCOgJ/mLXzx7tc/RoxDSwvgiBZ030s1mpL7F
         LvSMu5im5SGmZXY4woKhggcgU8/aO65De39+OUFiJNMSA6vCV60PwaEzRxPTk4vZBH
         yeJJJ6wNOne/L6PIttfcj3JvthYKT64QkcH2d1SeTC7GtSJDjH4BC4ZtStu22g5zqv
         aR7/RhXXYWiKJaamcvPf1JJLBbf0kuqruqYhMEr1N+JwTa64nf4JAQNlff/XasAkoS
         BoKxXeda2r/s3NFWhwnhzR1U772t+BdKnzimW5HHv3i9yUP/OW/vWchL40iz/EYNc9
         OOkZ228TwfsOw==
Message-ID: <5b8b45707e019c16852b2aa8c9b8928fbdc60008.camel@kernel.org>
Subject: Re: [PATCH] ceph: remove dead code in ceph_sync_write
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Wed, 11 Aug 2021 10:44:28 -0400
In-Reply-To: <87o8a4qc8f.fsf@suse.de>
References: <20210811111927.8417-1-jlayton@kernel.org>
         <87o8a4qc8f.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-11 at 15:37 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > We've already checked these flags near the top of the function and
> > bailed out if either were set.
> 
> The flags being checked at the top of the function are CEPH_OSDMAP_FULL
> and CEPH_POOL_FLAG_FULL; here we're checking the *_NEARFULL flags.
> Right?  (I had to look a few times to make sure my eyes were not lying.)
> 
> Cheers,

Oof. You're totally right. Dropping this patch!

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

