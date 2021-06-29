Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7C73B7521
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbhF2P3m (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:29:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232521AbhF2P3m (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6488F61DD2;
        Tue, 29 Jun 2021 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624980434;
        bh=Lg/C3EUd894+E8bv/E2SgY9ntkgrCRPxEgMDFsELISA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ftTdnEU+COpjOEd3e9uJeH8NSJRDFc0hjPq18bYqVbY3DEhXpgN4wNtRA3DvminQy
         tZ8mhzPJtEiiGUiwjnNF5fgOkufJwiOxjeUxexU2opGc6foMHXPO2WpUdaK1pFwY2O
         gvecj3QR5qG9nObuAhHhLcer0HBkBiVTZSla9ZU7qGyHKvpTZg1DMPvzjBX9NxKI5n
         uT381bVsQl2yeaQKDG/eqjW90OkoHpe6kvp7K9aPsGNTEov5xrB7VwfNK/wiZoU5zp
         mdQtEfCHnJb1xHrNzsz+E5gV2u2h2CkKTuYOk3UdRrhsG1o/Y3av0saaErT4Lb1CAJ
         SgmbMxSSEUTxQ==
Message-ID: <9d697fc5ed6a770f502d682d78ee418a19c2f246.camel@kernel.org>
Subject: Re: [PATCH 0/5] flush the mdlog before waiting on unsafe reqs
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 11:27:13 -0400
In-Reply-To: <20210629044241.30359-1-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the client requests who will have unsafe and safe replies from
> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
> (journal log) immediatelly, because they think it's unnecessary.
> That's true for most cases but not all, likes the fsync request.
> The fsync will wait until all the unsafe replied requests to be
> safely replied.
> 
> Normally if there have multiple threads or clients are running, the
> whole mdlog in MDS daemons could be flushed in time if any request
> will trigger the mdlog submit thread. So usually we won't experience
> the normal operations will stuck for a long time. But in case there
> has only one client with only thread is running, the stuck phenomenon
> maybe obvious and the worst case it must wait at most 5 seconds to
> wait the mdlog to be flushed by the MDS's tick thread periodically.
> 
> This patch will trigger to flush the mdlog in all the MDSes manually
> just before waiting the unsafe requests to finish.
> 
> 

This seems a bit heavyweight, given that you may end up sending
FLUSH_MDLOG messages to mds's on which you're not waiting. What might be
best is to scan the list of requests you're waiting on and just send
these messages to those mds's.

Is that possible here?

> 
> 
> Xiubo Li (5):
>   ceph: export ceph_create_session_msg
>   ceph: export iterate_sessions
>   ceph: flush mdlog before umounting
>   ceph: flush the mdlog before waiting on unsafe reqs
>   ceph: fix ceph feature bits
> 
>  fs/ceph/caps.c               | 35 ++++----------
>  fs/ceph/mds_client.c         | 91 +++++++++++++++++++++++++++---------
>  fs/ceph/mds_client.h         |  9 ++++
>  include/linux/ceph/ceph_fs.h |  1 +
>  4 files changed, 88 insertions(+), 48 deletions(-)
> 

-- 
Jeff Layton <jlayton@kernel.org>

