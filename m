Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B034DC566
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 13:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiCQMCn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 08:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiCQMCm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 08:02:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBC318FADD;
        Thu, 17 Mar 2022 05:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F418AB80E8A;
        Thu, 17 Mar 2022 12:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6FAC340E9;
        Thu, 17 Mar 2022 12:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647518479;
        bh=Qf8CBbHvzkdofb9fpNdW6CQM9HNMKy+UOcace2VJYCw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tdxDnyrbQ3jnvwbKN7ctQjVnoMcyTI0dYBfVhBAXFaZFNcyJ0WjMLi9BGyKlALHvL
         hXtKP+3jnMTbE8SrVCsfrl3pKxqoRzBF9m5txFRmwJRUNnX9NMUnm5cmCl33whIMBJ
         X3vW8nyoNp4NTB04PYRzNffMdIqhXEMDSmm9ET/RaWs8LMOjM610DISEgyi14rRcvu
         cjkdPrXDnNjOlyU4F/CoNwbbobxnXWHY3hCvNnQ9aDfjHH89kXxoI88gtALsWldwEz
         SbiFEjJeZrp2/anICt9K8uprD41kdKphA8UKIes+FtDK3UeHoYpvb+a5s8A7SXCWPn
         3naZaDM9tNqbg==
Message-ID: <c2f494b61674e63985e4e2a0fb3b6c503e17334b.camel@kernel.org>
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date:   Thu, 17 Mar 2022 08:01:17 -0400
In-Reply-To: <87wngshlzb.fsf@brahms.olymp>
References: <20220315161959.19453-1-lhenriques@suse.de>
         <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
         <329abedd9d9938de95bf4f5600acdcd6a846e6be.camel@kernel.org>
         <3c8b78c4-5392-b81c-e76f-64fcce4f3c0f@redhat.com>
         <87wngshlzb.fsf@brahms.olymp>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-17 at 11:11 +0000, Lu�s Henriques wrote:
> Xiubo Li <xiubli@redhat.com> writes:
> 
> > On 3/17/22 6:01 PM, Jeff Layton wrote:
> > > I'm not sure we want to worry about .snap directories here since they
> > > aren't "real". IIRC, snaps are inherited from parents too, so you could
> > > do something like
> > > 
> > >      mkdir dir1
> > >      mkdir dir1/.snap/snap1
> > >      mkdir dir1/dir2
> > >      fscrypt encrypt dir1/dir2
> > > 
> > > There should be nothing to prevent encrypting dir2, but I'm pretty sure
> > > dir2/.snap will not be empty at that point.
> > 
> > If we don't take care of this. Then we don't know which snapshots should do
> > encrypt/dencrypt and which shouldn't when building the path in lookup and when
> > reading the snapdir ?
> 
> In my patchset (which I plan to send a new revision later today, I think I
> still need to rebase it) this is handled by using the *real* snapshot
> parent inode.  If we're decrypting/encrypting a name for a snapshot that
> starts with a '_' character, we first find the parent inode for that
> snapshot and only do the operation if that parent is encrypted.
> 
> In the other email I suggested that we could prevent enabling encryption
> in a directory when there are snapshots above in the hierarchy.  But now
> that I think more about it, it won't solve any problem because you could
> create those snapshots later and then you would still need to handle these
> (non-encrypted) "_name_xxxx" snapshots anyway.
> 

Yeah, that sounds about right.

What happens if you don't have the snapshot parent's inode in cache?
That can happen if you (e.g.) are running NFS over ceph, or if you get
crafty with name_to_handle_at() and open_by_handle_at().

Do we have to do a LOOKUPINO in that case or does the trace contain that
info? If it doesn't then that could really suck in a big hierarchy if
there are a lot of different snapshot parent inodes to hunt down.

I think this is a case where the client just doesn't have complete
control over the dentry name. It may be better to just not encrypt them
if it's too ugly.

Another idea might be to just use the same parent inode (maybe the
root?) for all snapshot names. It's not as secure, but it's probably
better than nothing.
-- 
Jeff Layton <jlayton@kernel.org>
