Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4674D9E5C
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 16:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbiCOPLa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 11:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbiCOPL2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 11:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2DC13F10
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 08:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27BA261031
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297DEC340ED;
        Tue, 15 Mar 2022 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647357014;
        bh=JYfOJTdqbNRBQP6FN1OHBF1UQsTRn0sFNGHpsKReXK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nsq6GWOEd9lrlgTjhOqX5tvbSfvI7IoZuQ/t3bBoycXD6XtsmKT41QnZzCHeIxR3T
         5xPrYeRlxXi9YO5U8RELd3LtV//8RNNH13sGGOTpJWopfU+rAYe5hSFuDUbVIzgcAF
         TVWwU5ETxNEZWXD3wEW+uJwEW/AfinBCC+Z0Pfj4PS/GdG8QqXXnrVsTuXzDdx5HcZ
         4J7dbpOkwkIyjPiqYfv5hVb2RtQPF6hXCGN5JO9zetSc/PR24isPDhhCCT7n0wynhQ
         rm8JeAwJ3mOccRtu4717B1aQqzFgMTQNeoCu6foMkldSFsWiw5fKJ6CtpYWu+Z2cQc
         eKCP1/ApoVp6A==
Message-ID: <1128c0fd550cef3566e1921e28837b31748eb2bd.camel@kernel.org>
Subject: Re: [PATCH] ceph: get snap_rwsem read lock in handle_cap_export for
 ceph_add_cap
From:   Jeff Layton <jlayton@kernel.org>
To:     Niels Dossche <dossche.niels@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 15 Mar 2022 11:10:12 -0400
In-Reply-To: <1ce10b6639b34759a701602d9172aec59e23c03b.camel@kernel.org>
References: <20220314200717.52033-1-dossche.niels@gmail.com>
         <1ce10b6639b34759a701602d9172aec59e23c03b.camel@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-15 at 08:26 -0400, Jeff Layton wrote:
> On Mon, 2022-03-14 at 21:07 +0100, Niels Dossche wrote:
> > ceph_add_cap says in its function documentation that the caller should
> > hold the read lock on the session snap_rwsem. Furthermore, not only
> > ceph_add_cap needs that lock, when it calls to ceph_lookup_snap_realm it
> > eventually calls ceph_get_snap_realm which states via lockdep that
> > snap_rwsem needs to be held. handle_cap_export calls ceph_add_cap
> > without that mdsc->snap_rwsem held. Thus, since ceph_get_snap_realm
> > and ceph_add_cap both need the lock, the common place to acquire that
> > lock is inside handle_cap_export.
> > 
> > Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
> > ---
> >  fs/ceph/caps.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index b472cd066d1c..0dd60db285b1 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -3903,8 +3903,10 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
> >  		/* add placeholder for the export tagert */
> >  		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
> >  		tcap = new_cap;
> > +		down_read(&mdsc->snap_rwsem);
> >  		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
> >  			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
> > +		up_read(&mdsc->snap_rwsem);
> >  
> >  		if (!list_empty(&ci->i_cap_flush_list) &&
> >  		    ci->i_auth_cap == tcap) {
> 
> Looks good. The other ceph_add_cap callsites already hold this.
> 
> Merged into ceph testing branch.
> 


Oops, spoke too soon. This patch calls down_read (a potentially sleeping
function) while holding the i_ceph_lock spinlock. I think you'll need to
take the rwsem earlier in the function, before taking the spinlock.

Dropped from testing branch for now...
-- 
Jeff Layton <jlayton@kernel.org>
