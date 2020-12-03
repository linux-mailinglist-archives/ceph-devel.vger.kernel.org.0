Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061B32CDB83
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Dec 2020 17:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501904AbgLCQqp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Dec 2020 11:46:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728092AbgLCQqp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Dec 2020 11:46:45 -0500
Message-ID: <ac5253d71ea50c8f5b4e50a07a1a0180abd58562.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607013964;
        bh=EYF3ExxOP6s9BMfYnhJHVteOi2VSJVIgWwwuNktfaI0=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=IrRKBj5zbma6oWDa8Xr9zIw25Zb2pVC5ny95umxHIgsTl7OmjmY1QGshtso5SL4nS
         YeVBJE0NqbNRGIFS+nyiWV6WBzFWQLhdBMAgunqzpPq5FqKV0OmPpQECMaywb4xwQm
         K8s8RSCj4zIaVITTzsB7x5cV4/HvAaxME4yhO6Cny9MjXiwo2CKABFsw6unPTiR+J3
         rlMeZlllqB9rBpHe+m2fcrBHDB7RYmHUFACyeNikevz8maA2IMA8np5oQt7B8sO96x
         4s7HunqEDL46UrTSiLFMg30Bt6Gojm1bV0bTbuscI6NkNEaFOpXX0Qm/Vxoc2Xtzdz
         dFjj9I2a+7szw==
Subject: Re: Investigate busy ceph-msgr worker thread
From:   Jeff Layton <jlayton@kernel.org>
To:     Stefan Kooman <stefan@bit.nl>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 03 Dec 2020 11:46:02 -0500
In-Reply-To: <9afdb763-4cf6-3477-bd32-762840c0c0a5@bit.nl>
References: <9afdb763-4cf6-3477-bd32-762840c0c0a5@bit.nl>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-12-03 at 12:01 +0100, Stefan Kooman wrote:
> Hi,
> 
> We have a cephfs linux kernel (5.4.0-53-generic) workload (rsync) that 
> seems to be limited by a single ceph-msgr thread (doing close to 100% 
> cpu). We would like to investigate what this thread is so busy with. 
> What would be the easiest way to do this? On a related note: what would 
> be the best way to scale cephfs client performance for a single process 
> (if at all possible)?
> 
> Thanks for any pointers.
> 

Usually kernel profiling (a'la perf) is the way to go about this. You
may want to consider trying more recent kernels and see if they fare any
better. With a new enough MDS and kernel, you can try enabling async
creates as well, and see whether that helps performance any.

As far as optimizing for a single process, there's not a lot you can do,
really.
-- 
Jeff Layton <jlayton@kernel.org>

