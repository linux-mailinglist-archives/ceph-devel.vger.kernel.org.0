Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0548555A
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jan 2022 16:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241408AbiAEPEH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jan 2022 10:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241199AbiAEPDK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jan 2022 10:03:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB6DC0611FD
        for <ceph-devel@vger.kernel.org>; Wed,  5 Jan 2022 07:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 053A3B81BA7
        for <ceph-devel@vger.kernel.org>; Wed,  5 Jan 2022 15:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330EBC36AE9;
        Wed,  5 Jan 2022 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641394987;
        bh=xGSaiEv7QGMuNpAdIiG9qAd6bf0ylFOezToj/DlcvL8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=u5IRjjlHoHuqIlUy9ZGLtn7HcuUgzN/ic5tvIy+YyoaTRfDJHTn7Zr/HVaqcM9KtY
         SkkNqsoY0paExp5nl9lbx+SQZliG9SixcMARZVy8LkeXDUNxmuZcsIFVvUt2WZWZO6
         4xDlC+0XR019zAX2wevtXZMs4pekjPTbLkmc1lCnEjgYoaMC9PojMu33zTF52w07Ez
         8c72vvoFNtO/tvuJ0qrUtAc3okZWGDvnhtFLfThEmmon0FYytkObCKyhC7gpq0UCz8
         nzMs0CVpC4RfcVFGRi9B9c3+0PHJ31y+ptovh8NvRN22yoSco/FzHLl81T81zA5Tnw
         Aam6HTT6RNWRQ==
Message-ID: <3864f17da4018151359785b9a49140e18fdb30bb.camel@kernel.org>
Subject: Re: [PATCH 02/12] ceph: handle idmapped mounts in
 create_request_message()
From:   Jeff Layton <jlayton@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 05 Jan 2022 10:03:06 -0500
In-Reply-To: <20220105141023.vrrbfhti5apdvkz7@wittgenstein>
References: <20220104140414.155198-1-brauner@kernel.org>
         <20220104140414.155198-3-brauner@kernel.org>
         <cdd3f83fd64cc308a7694875c1e4a35f0d052429.camel@kernel.org>
         <20220105141023.vrrbfhti5apdvkz7@wittgenstein>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-01-05 at 15:10 +0100, Christian Brauner wrote:
> On Tue, Jan 04, 2022 at 12:40:51PM -0500, Jeff Layton wrote:
> > On Tue, 2022-01-04 at 15:04 +0100, Christian Brauner wrote:
> > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > > 
> > > Inode operations that create a new filesystem object such as ->mknod,
> > > ->create, ->mkdir() and others don't take a {g,u}id argument explicitly.
> > > Instead the caller's fs{g,u}id is used for the {g,u}id of the new
> > > filesystem object.
> > > 
> > > Cephfs mds creation request argument structures mirror this filesystem
> > > behavior. They don't encode a {g,u}id explicitly. Instead the caller's
> > > fs{g,u}id that is always sent as part of any mds request is used by the
> > > servers to set the {g,u}id of the new filesystem object.
> > > 
> > > In order to ensure that the correct {g,u}id is used map the caller's
> > > fs{g,u}id for creation requests. This doesn't require complex changes.
> > > It suffices to pass in the relevant idmapping recorded in the request
> > > message. If this request message was triggered from an inode operation
> > > that creates filesystem objects it will have passed down the relevant
> > > idmaping. If this is a request message that was triggered from an inode
> > > operation that doens't need to take idmappings into account the initial
> > > idmapping is passed down which is an identity mapping and thus is
> > > guaranteed to leave the caller's fs{g,u}id unchanged.,u}id is sent.
> > > 
> > > The last few weeks before Christmas 2021 I have spent time not just
> > > reading and poking the cephfs kernel code but also took a look at the
> > > ceph mds server userspace to ensure I didn't miss some subtlety.
> > > 
> > > This made me aware of one complication to solve. All requests send the
> > > caller's fs{g,u}id over the wire. The caller's fs{g,u}id matters for the
> > > server in exactly two cases:
> > > 
> > > 1. to set the ownership for creation requests
> > > 2. to determine whether this client is allowed access on this server
> > > 
> > > Case 1. we already covered and explained. Case 2. is only relevant for
> > > servers where an explicit uid access restriction has been set. That is
> > > to say the mds server restricts access to requests coming from a
> > > specific uid. Servers without uid restrictions will grant access to
> > > requests from any uid by setting MDS_AUTH_UID_ANY.
> > > 
> > > Case 2. introduces the complication because the caller's fs{g,u}id is
> > > not just used to record ownership but also serves as the {g,u}id used
> > > when checking access to the server.
> > > 
> > > Consider a user mounting a cephfs client and creating an idmapped mount
> > > from it that maps files owned by uid 1000 to be owned uid 0:
> > > 
> > > mount -t cephfs -o [...] /unmapped
> > > mount-idmapped --map-mount 1000:0:1 /idmapped
> > > 
> > > That is to say if the mounted cephfs filesystem contains a file "file1"
> > > which is owned by uid 1000:
> > > 
> > > - looking at it via /unmapped/file1 will report it as owned by uid 1000
> > >   (One can think of this as the on-disk value.)
> > > - looking at it via /idmapped/file1 will report it as owned by uid 0
> > > 
> > > Now, consider creating new files via the idmapped mount at /idmapped.
> > > When a caller with fs{g,u}id 1000 creates a file "file2" by going
> > > through the idmapped mount mounted at /idmapped it will create a file
> > > that is owned by uid 1000 on-disk, i.e.:
> > > 
> > > - looking at it via /unmapped/file2 will report it as owned by uid 1000
> > > - looking at it via /idmapped/file2 will report it as owned by uid 0
> > > 
> > > Now consider an mds server that has a uid access restriction set and
> > > only grants access to requests from uid 0.
> > > 
> > > If the client sends a creation request for a file e.g. /idmapped/file2
> > > it will send the caller's fs{g,u}id idmapped according to the idmapped
> > > mount. So if the caller has fs{g,u}id 1000 it will be mapped to {g,u}id
> > > 0 in the idmapped mount and will be sent over the wire allowing the
> > > caller access to the mds server.
> > > 
> > > However, if the caller is not issuing a creation request the caller's
> > > fs{g,u}id will be send without the mount's idmapping applied. So if the
> > > caller that just successfully created a new file on the restricted mds
> > > server sends a request as fs{g,u}id 1000 access will be refused. This
> > > however is inconsistent.
> > > 
> > 
> > IDGI, why would you send the fs{g,u}id without the mount's idmapping
> > applied in this case? ISTM that idmapping is wholly a client-side
> > feature, and that you should always map id's regardless of whether
> > you're creating or not.
> 
> Since the idmapping is a property of the mount and not a property of the
> caller the caller's fs{g,u}id aren't mapped. What is mapped are the
> inode's i{g,u}id when accessed from a particular mount.
> 
> The fs{g,u}id are only ever mapped when a new filesystem object is
> created. So if I have an idmapped mount that makes it so that files
> owned by 1000 on-disk appear to be owned by uid 0 then a user with uid 0
> creating a new file will create files with uid 1000 on-disk when going
> through that mount. For cephfs that'd be the uid we would be sending
> with creation requests as I've currently written it.
> 
> So then when the user looks at the file it created it will see it as
> being owned by uid 0 from that idmapped mount (whereas on-disk it's
> 1000). But the user's fs{g,u}id isn't per se changed when going through
> that mount. So in my opinion I was thinking that the server with access
> permissions set would want to always check permissions on the users
> "raw" fs{g,u}id. That would mean I'd have to change the patch obviously.
> My suggestion was to send the {g,u}id the file will be created with
> separately. The alternative would be to not just pass the idmapping into
> the creation iop's but into all iops so that we can always map it for
> cephfs. But this would mean a lot of vfs changes for one filesystem. So
> if we could first explore alternatives approaches I'd be grateful.
> 

You'll probably need to do this for NFS anyway, if you have plans in
that direction. Extending the protocol there will be much more
difficult. I think that approach sounds much cleaner overall.

> (I'll be traveling for the latter half of this week starting today at
> CET afternoon so apologies but I'll probably take some time to respond.)

Ok. I guess you can get away with this on a local fs because the backend
storage doesn't really care about uid/gids at all. The only permission
checking is done in the kernel and you (presumably) can just map the
inode's uid/gid prior to checking permissions.

I'm a little confused as to what you mean by "raw" id here. In your
earlier example with a mapping of 1000:0:1, which one is the raw id for
the actual user?
-- 
Jeff Layton <jlayton@kernel.org>
