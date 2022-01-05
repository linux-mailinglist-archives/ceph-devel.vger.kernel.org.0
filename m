Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A43A48541D
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jan 2022 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240585AbiAEOLO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jan 2022 09:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240578AbiAEOLO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jan 2022 09:11:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DDDC061761
        for <ceph-devel@vger.kernel.org>; Wed,  5 Jan 2022 06:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A258DB81AAA
        for <ceph-devel@vger.kernel.org>; Wed,  5 Jan 2022 14:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0893C36AE0;
        Wed,  5 Jan 2022 14:11:07 +0000 (UTC)
Date:   Wed, 5 Jan 2022 15:11:04 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] ceph: handle idmapped mounts in
 create_request_message()
Message-ID: <20220105141104.df6nqtqkahis55xa@wittgenstein>
References: <20220104140414.155198-1-brauner@kernel.org>
 <20220104140414.155198-3-brauner@kernel.org>
 <cdd3f83fd64cc308a7694875c1e4a35f0d052429.camel@kernel.org>
 <CAJ4mKGbKVcvoYGi3go3-VtMhjXES5iMyof9qMfL+8AyHiPKBNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJ4mKGbKVcvoYGi3go3-VtMhjXES5iMyof9qMfL+8AyHiPKBNA@mail.gmail.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 04, 2022 at 11:33:33AM -0800, Gregory Farnum wrote:
> On Tue, Jan 4, 2022 at 9:41 AM Jeff Layton <jlayton@kernel.org> wrote:
> >
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
> Yeah, I'm confused. We want the fs {g,u}id to be consistent throughout
> the request pipeline and to reflect the actual Ceph user all the way
> through the server-side pipeline. What if client.greg is only
> authorized to work as uid 12345 and access /users/greg/; why would you
> send in a bunch of requests as root just because I mounted that way
> inside my own space?
> 
> This might be more obvious in the userspace Client, which is already
> set up to be friendlier to mapped users for Ganesha etc:
> mknod (https://github.com/ceph/ceph/blob/master/src/client/Client.cc#L7297)
> and similar calls receive a "UserPerm" from the caller specifying who
> the call should be performed as, and they pass that in to the generic
> make_requst() function
> (https://github.com/ceph/ceph/blob/master/src/client/Client.cc#L1778)
> which uses it to set the uid and gid fields you found in the message.

Thank you for those links. I think I read through this code before and
I'll give it another read.
