Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C937096B7
	for <lists+ceph-devel@lfdr.de>; Fri, 19 May 2023 13:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjESLoa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 May 2023 07:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjESLo3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 May 2023 07:44:29 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CC2F7
        for <ceph-devel@vger.kernel.org>; Fri, 19 May 2023 04:44:27 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 68AAE3F22B
        for <ceph-devel@vger.kernel.org>; Fri, 19 May 2023 11:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684496664;
        bh=SuQmav5nVw6K//cKHyaA8ZnOuQ0RbBtZoHAQ+XloBZs=;
        h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
         Mime-Version:Content-Type;
        b=I5nPVEh4Cqi+TJJm+8ADE+kuLKzFAU8kMKrTcKykK04wJ+ckTHeR+kvASM7ok0AiF
         2dS02ySAeHoAS3ghc5ZBLTdzxECewsPZpA7xQ9VbOivrmdrCbL6BD2n7ZTx+XEbTX4
         nU6Hjm86G0CEMEcakxpBc6qSOX+QB40uJKRdGY1NAXgPbxPa/KvO2irZxwXR26W7z9
         +ly+gHHVdwmhEOW2lKAkmWRz5VvvUq92xO8GvzeEEqKZafx8skNXie4Dx1mgPwnGVX
         1URt09D1RM1T2APMlxBQaYmT/V+0oAn3CFl8XTHYkCDuLuZm94BDr9dc8mcVQ+8yeq
         QRRp/r1dvwDsg==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-96a0ce9215bso336168266b.2
        for <ceph-devel@vger.kernel.org>; Fri, 19 May 2023 04:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684496663; x=1687088663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SuQmav5nVw6K//cKHyaA8ZnOuQ0RbBtZoHAQ+XloBZs=;
        b=XLhYHZdOm4cBP6ns7IisNWzglGvUEWZJbc7cWrT799jOQSZbyLPC2b9gZcpkBH+bji
         8UsKAzuHICMGW4IjsPMaZGW3+0iY02Nz+oCgboovOeyjNwXBs5wP0AqvWHM4n54JXmM/
         3NNdECMVBIS0DgNJYRI/r4znDIoMUevsZ/5FCFRXoCzlZSK+evmiJgfzzuN6sbb8Rt+R
         YO7MbSEQR8+9K9PwEcJAqXa9dy++aZI6aJgL0JjBElvcE8f4RbPS5cwwC537i42hG3U6
         58WLpnH67M0MG82UZFvZhKR7tPbW69S0npU042Xlq1A7cB0eSbx4HKXL0uYaRPJh1hV+
         g77A==
X-Gm-Message-State: AC+VfDw+Jk9dmbdsHDP2NdkhyfRrpO6puvocPHAeY5p16J4LhR8//yM/
        0rW8NYNH7Y5tOmyYPWWBC3/xTGxhUm2OAbIrcfTxwxdbSAPLC67DQ++BcqzB1KwjM8f/yxtYxXc
        MBd6e+Ym9AoLW/o40Fy7Q2L4QJQqgc4gHX7BPk9Y=
X-Received: by 2002:a17:907:a0e:b0:96b:48d2:1997 with SMTP id bb14-20020a1709070a0e00b0096b48d21997mr1215713ejc.65.1684496662836;
        Fri, 19 May 2023 04:44:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FE+hXPH33nTQQcDL+OP+kZafX2OEeALcarACJg04cUuqZ/RNwYn1PiYopDUKIKJdQJqFcoA==
X-Received: by 2002:a17:907:a0e:b0:96b:48d2:1997 with SMTP id bb14-20020a1709070a0e00b0096b48d21997mr1215693ejc.65.1684496662363;
        Fri, 19 May 2023 04:44:22 -0700 (PDT)
Received: from amikhalitsyn (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id lc17-20020a170906f91100b0096f0c8beebbsm2190903ejb.79.2023.05.19.04.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:44:21 -0700 (PDT)
Date:   Fri, 19 May 2023 13:44:20 +0200
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] ceph: handle idmapped mounts in
 create_request_message()
Message-Id: <20230519134420.2d04e5f70aad15679ab566fc@canonical.com>
In-Reply-To: <20220105141023.vrrbfhti5apdvkz7@wittgenstein>
References: <20220104140414.155198-1-brauner@kernel.org>
        <20220104140414.155198-3-brauner@kernel.org>
        <cdd3f83fd64cc308a7694875c1e4a35f0d052429.camel@kernel.org>
        <20220105141023.vrrbfhti5apdvkz7@wittgenstein>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear colleagues,

On Wed, 5 Jan 2022 15:10:23 +0100
Christian Brauner <christian.brauner@ubuntu.com> wrote:

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

I can't understand which kind of operations we are talking about here.
Right now almost all inode_operations are taking struct mnt_idmap as a parameter
(at the moment of this series was posted it was struct user_namespace, but that's not important).

The only iops those are not taking idmap is lookup, readlink, fiemap, update_time, atomic_open
and a few more. So, we want to pass struct mnt_idmap to them to always map current_fs{g,u}id
according to a mount idmapping? As Christian pointed above:

> Since the idmapping is a property of the mount and not a property of the
> caller the caller's fs{g,u}id aren't mapped. What is mapped are the
> inode's i{g,u}id when accessed from a particular mount.

If we want to go this way then we don't need to pass mnt_idmap to any additional inode ops
and the current approach works fine. Please, correct me if I'm wrong.

> 
> (I'll be traveling for the latter half of this week starting today at
> CET afternoon so apologies but I'll probably take some time to respond.)
>

P.S.

I'm trying to make a respin for this series, I've made a formal rebase on top of
the current Linux kernel tree and fixed it according to the Jeff's review comment:
https://lore.kernel.org/all/041afbfd171915d62ab9a93c7a35d9c9d5c5bf7b.camel@kernel.org/

This thing is really important for LXD/LXC project so I'll be happy to help with pushing
this forward.

Current tree:
https://github.com/mihalicyn/linux/commits/fs.idmapped.ceph.v2

Kind regards,
Alex
