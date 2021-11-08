Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4824481D3
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 15:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240507AbhKHOev (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 Nov 2021 09:34:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239345AbhKHOev (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 09:34:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 244BE61076;
        Mon,  8 Nov 2021 14:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636381926;
        bh=gLEqF5XK0RFlZY7yYWKohW6yvwW16yQtJwDoeqHcmSY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R5yTwOqQwsaSuU9+oz9LC4ebhFBUyl5Es/8Sa3HIr/1mvYsd5TrFbvWBgSlWdzz+y
         gvCQSCF/C4Calzgn9wreoXkbry0VLLORdRzh/YHGqvGuoQ51Fzzeqph9mV0dr83god
         ZaLjB7RMGM067UflbxiEQbrkP9iC+hzbXhZhZKQty7Oep1uzsPuoZkGiv0t8mjUPGG
         oO1xOymC2Iy7xpoqI6iGDNDD/pxTm0PsuCUhjbfj3BOkZrQhkvEcF9yhJH2Y9d3a4N
         THITRgx2FZKKKzAvSycuYNTARDLsYEW3avwXf6Ijk6ja/KzLN1HaJRHEygGWGL7uig
         ScaUION6psOkA==
Message-ID: <9f5d8e1e3e2b08500ca53805d9ef1d73c0ca306a.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: misc fixes for the fscrypt truncate size
 handling
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, khiremat@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 08 Nov 2021 09:32:05 -0500
In-Reply-To: <20211108135012.79941-1-xiubli@redhat.com>
References: <20211108135012.79941-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-11-08 at 21:50 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Hi Jeff,
> 
> The #1 could be squashed to the previous "ceph: add truncate size handling support for fscrypt" commit.
> The #2 could be squashed to the previous "ceph: fscrypt_file field handling in MClientRequest messages" commit.
> 
> Thanks.
> 
> Xiubo Li (2):
>   ceph: fix possible crash and data corrupt bugs
>   ceph: there is no need to round up the sizes when new size is 0
> 
>  fs/ceph/inode.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Done. I folded these into the patches like you suggested above.
-- 
Jeff Layton <jlayton@kernel.org>
