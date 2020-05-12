Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EFE1CF93B
	for <lists+ceph-devel@lfdr.de>; Tue, 12 May 2020 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgELPdP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 12 May 2020 11:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgELPdP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 12 May 2020 11:33:15 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 711C3206CC;
        Tue, 12 May 2020 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589297594;
        bh=MGNDIi2DyyBf46adeF594QK2+2EWopO5Ae4Gj1N0AlI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EnDtcll9qqKe2+FI0bVt9MTugtEDeC3y739De7OcEaJy9OfKKXfqW3NbCgPCj9oGN
         Fnw3Ik64IAJQTTd7ED+9xGY939lN8v26mGSHkQJWBVYNg0ZNzwTbQlh6SgFLFaORHb
         OgkokPRSRAoMUAcQYfLJh02zaXcEoY4SNMHjjrJM=
Message-ID: <ef6459452ab8156d69e2b41b35f3d388d7a3197c.camel@kernel.org>
Subject: Re: Help understanding xfstest generic/467 failure
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     ceph-devel@vger.kernel.org
Date:   Tue, 12 May 2020 11:33:13 -0400
In-Reply-To: <878shx190r.fsf@suse.com>
References: <878shx190r.fsf@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-05-12 at 16:13 +0100, Luis Henriques wrote:
> Hi Jeff,
> 
> I've been looking at xfstest generic/467 failure in cephfs, and I simply
> can not decide if it's a genuine bug on ceph kernel code.  Since you've
> recently been touching the ceph_unlink code maybe you could help me
> understanding what's going on.
> 
> generic/467 runs a couple of tests using src/open_by_handle, but the one
> failing can be summarized with the following:
> 
> - get a handle to /cephfs/myfile using name_to_handle_at(2)
> - open(2) file /cephfs/myfile
> - unlink(2) /cephfs/myfile
> - drop caches
> - open_by_handle_at(2) => returns -ESTALE
> 
> This test succeeds opening the handle with other (local) filesystems
> (maybe I should run it with other networked filesystem such as NFS).
> 
> The -ESTALE is easy to trace to __fh_to_dentry, where inode->i_nlink is
> checked against 0.  My question is: should we really be testing the
> i_nlink here?  We dropped the name, but the file may still be there (as in
> this case).
> 
> I guess I'm missing something, but hopefully you'll be able to shed some
> light on this.  Thanks in advance for any help you may provide!

Yeah, I took a brief look at this a while back and never got back to
looking at it again. I think cephfs's behavior is wrong here. We should
be able to look up an open-but-unlinked file by filehandle.

That said those checks went in via commit 570df4e9c23f8, and it looks
like it was deliberately added to __fh_to_dentry. I'm unclear as to why.
It may be interesting to remove the i_nlink checks and see whether it
breaks anything?

-- 
Jeff Layton <jlayton@kernel.org>

