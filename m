Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A5C4D635B
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 15:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349154AbiCKOY2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 09:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiCKOY1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 09:24:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFD3121520;
        Fri, 11 Mar 2022 06:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3F33B82A73;
        Fri, 11 Mar 2022 14:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57673C340E9;
        Fri, 11 Mar 2022 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647008600;
        bh=1aN/i+7VUozNB0qC97c4ZeA4vReDaNrLMrM52MVDiqM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iWp63nefKqlwopNSOeQjJfPZS0jOgdS3OVqEuLh1QBg+B54WG7dbnHO4oiKB+dWeI
         T09XmYXAyBoPti8b4AFAGqaAIKhi15UzCnEVqsJVaZ5P64HXgUC3GZ8FWZ2i0BewHv
         /G0rJAH0LWNd2XHftMPhKzUNi0y1PYPGeWrcnaw2HKTAMj6n8X2a6U04J+Y7xgLKud
         RrBplYiupBHYcKx2YhFyuHGFpeFaW9YwyBPypRNWNzP607oRAEJQeb6vR18k4N/iOu
         B1IuzRr5+gaotbrWZZdmbnHpmXkjwo9Cwh2o5SBelBjGe3ccVNxWO9TyiWIY8DM7Zw
         PpQrW8DpXtHyw==
Message-ID: <66c1fc64b4ec8b25a1ed625a4b61721a00d2e090.camel@kernel.org>
Subject: Re: [PATCH v3 00/20] netfs: Prep for write helpers
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>, linux-cachefs@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        David Wysochanski <dwysocha@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 11 Mar 2022 09:23:18 -0500
In-Reply-To: <164692883658.2099075.5745824552116419504.stgit@warthog.procyon.org.uk>
References: <164692883658.2099075.5745824552116419504.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-10 at 16:13 +0000, David Howells wrote:
> Having had a go at implementing write helpers and content encryption
> support in netfslib, it seems that the netfs_read_{,sub}request structs and
> the equivalent write request structs were almost the same and so should be
> merged, thereby requiring only one set of alloc/get/put functions and a
> common set of tracepoints.
> 
> Merging the structs also has the advantage that if a bounce buffer is added
> to the request struct, a read operation can be performed to fill the bounce
> buffer, the contents of the buffer can be modified and then a write
> operation can be performed on it to send the data wherever it needs to go
> using the same request structure all the way through.  The I/O handlers
> would then transparently perform any required crypto.  This should make it
> easy to perform RMW cycles if needed.
> 
> The potentially common functions and structs, however, by their names all
> proclaim themselves to be associated with the read side of things.  The
> bulk of these changes alter this in the following ways:
> 
>  (1) Rename struct netfs_read_{,sub}request to netfs_io_{,sub}request.
> 
>  (2) Rename some enums, members and flags to make them more appropriate.
> 
>  (3) Adjust some comments to match.
> 
>  (4) Drop "read"/"rreq" from the names of common functions.  For instance,
>      netfs_get_read_request() becomes netfs_get_request().
> 
>  (5) The ->init_rreq() and ->issue_op() methods become ->init_request() and
>      ->issue_read().  I've kept the latter as a read-specific function and
>      in another branch added an ->issue_write() method.
> 
> The driver source is then reorganised into a number of files:
> 
> 	fs/netfs/buffered_read.c	Create read reqs to the pagecache
> 	fs/netfs/io.c			Dispatchers for read and write reqs
> 	fs/netfs/main.c			Some general miscellaneous bits
> 	fs/netfs/objects.c		Alloc, get and put functions
> 	fs/netfs/stats.c		Optional procfs statistics.
> 
> and future development can be fitted into this scheme, e.g.:
> 
> 	fs/netfs/buffered_write.c	Modify the pagecache
> 	fs/netfs/buffered_flush.c	Writeback from the pagecache
> 	fs/netfs/direct_read.c		DIO read support
> 	fs/netfs/direct_write.c		DIO write support
> 	fs/netfs/unbuffered_write.c	Write modifications directly back
> 
> Beyond the above changes, there are also some changes that affect how
> things work:
> 
>  (1) Make fscache_end_operation() generally available.
> 
>  (2) In the netfs tracing header, generate enums from the symbol -> string
>      mapping tables rather than manually coding them.
> 
>  (3) Add a struct for filesystems that uses netfslib to put into their
>      inode wrapper structs to hold extra state that netfslib is interested
>      in, such as the fscache cookie.  This allows netfslib functions to be
>      set in filesystem operation tables and jumped to directly without
>      having to have a filesystem wrapper.
> 
>  (4) Add a member to the struct added in (3) to track the remote inode
>      length as that may differ if local modifications are buffered.  We may
>      need to supply an appropriate EOF pointer when storing data (in AFS
>      for example).
> 
>  (5) Pass extra information to netfs_alloc_request() so that the
>      ->init_request() hook can access it and retain information to indicate
>      the origin of the operation.
> 
>  (6) Make the ->init_request() hook return an error, thereby allowing a
>      filesystem that isn't allowed to cache an inode (ceph or cifs, for
>      example) to skip readahead.
> 
>  (7) Switch to using refcount_t for subrequests and add tracepoints to log
>      refcount changes for the request and subrequest structs.
> 
>  (8) Add a function to consolidate dispatching a read request.  Similar
>      code is used in three places and another couple are likely to be added
>      in the future.
> 
> 
> The patches can be found on this branch:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=fscache-next
> 
> This is based on top of ceph's master branch as some of the patches
> conflict.
> 
> David
> ---
> 
> Changes
> =======
> ver #3)
>  - Rebased one patch back on the ceph tree as the top patch got removed[4].
>  - Split out the bit to move ceph cap-getting on readahead out from the
>    patch adding an inode context[5].
>  - Made ceph_init_request() store the caps got in rreq->netfs_priv for
>    later freeing.
>  - Comment the need to keep the netfs inode context contiguous with the VFS
>    inode struct[6].
>  - Altered the traces to use 'R=' consistently to denote a request debug ID.
>  
> ver #2)
>  - Changed kdoc references to renamed files[1].
>  - Switched the begin-read-function patch and the prepare-to-split patch as
>    fewer functions then need unstatic'ing.
>  - Fixed an uninitialised var in netfs_begin_read()[2][3].
>  - Fixed a refleak caused by an unremoved line when netfs_begin_read() was
>    introduced.
>  - Used "#if IS_ENABLED()" in netfs_i_cookie(), not "#ifdef".
>  - Implemented missing bit of ceph readahead through netfs_readahead().
>  - Rearranged the patch order to make the ceph readahead possible.
> 
> Link: https://lore.kernel.org/r/20220303202811.6a1d53a1@canb.auug.org.au/ [1]
> Link: https://lore.kernel.org/r/20220303163826.1120936-1-nathan@kernel.org/ [2]
> Link: https://lore.kernel.org/r/20220303235647.1297171-1-colin.i.king@gmail.com/ [3]
> Link: https://lore.kernel.org/r/527234d849b0de18b326d6db0d59070b70d19b7e.camel@kernel.org/ [4]
> Link: https://lore.kernel.org/r/8af0d47f17d89c06bbf602496dd845f2b0bf25b3.camel@kernel.org/ [5]
> Link: https://lore.kernel.org/r/beaf4f6a6c2575ed489adb14b257253c868f9a5c.camel@kernel.org/ [6]
> Link: https://lore.kernel.org/r/164622970143.3564931.3656393397237724303.stgit@warthog.procyon.org.uk/ # v1
> Link: https://lore.kernel.org/r/164678185692.1200972.597611902374126174.stgit@warthog.procyon.org.uk/ # v2
> 
> ---
> David Howells (19):
>       netfs: Generate enums from trace symbol mapping lists
>       netfs: Rename netfs_read_*request to netfs_io_*request
>       netfs: Finish off rename of netfs_read_request to netfs_io_request
>       netfs: Split netfs_io_* object handling out
>       netfs: Adjust the netfs_rreq tracepoint slightly
>       netfs: Trace refcounting on the netfs_io_request struct
>       netfs: Trace refcounting on the netfs_io_subrequest struct
>       netfs: Adjust the netfs_failure tracepoint to indicate non-subreq lines
>       netfs: Refactor arguments for netfs_alloc_read_request
>       netfs: Change ->init_request() to return an error code
>       ceph: Make ceph_init_request() check caps on readahead
>       netfs: Add a netfs inode context
>       netfs: Add a function to consolidate beginning a read
>       netfs: Prepare to split read_helper.c
>       netfs: Rename read_helper.c to io.c
>       netfs: Split fs/netfs/read_helper.c
>       netfs: Split some core bits out into their own file
>       netfs: Keep track of the actual remote file size
>       afs: Maintain netfs_i_context::remote_i_size
> 
> Jeffle Xu (1):
>       fscache: export fscache_end_operation()
> 
> 
>  Documentation/filesystems/netfs_library.rst |  140 ++-
>  fs/9p/cache.c                               |   10 +-
>  fs/9p/v9fs.c                                |    4 +-
>  fs/9p/v9fs.h                                |   13 +-
>  fs/9p/vfs_addr.c                            |   62 +-
>  fs/9p/vfs_inode.c                           |   13 +-
>  fs/afs/dynroot.c                            |    1 +
>  fs/afs/file.c                               |   41 +-
>  fs/afs/inode.c                              |   32 +-
>  fs/afs/internal.h                           |   23 +-
>  fs/afs/super.c                              |    4 +-
>  fs/afs/write.c                              |   10 +-
>  fs/cachefiles/io.c                          |   10 +-
>  fs/ceph/addr.c                              |  116 +-
>  fs/ceph/cache.c                             |   28 +-
>  fs/ceph/cache.h                             |   15 +-
>  fs/ceph/inode.c                             |    6 +-
>  fs/ceph/super.h                             |   17 +-
>  fs/cifs/cifsglob.h                          |   10 +-
>  fs/cifs/fscache.c                           |   19 +-
>  fs/cifs/fscache.h                           |    2 +-
>  fs/fscache/internal.h                       |   11 -
>  fs/netfs/Makefile                           |    8 +-
>  fs/netfs/buffered_read.c                    |  428 +++++++
>  fs/netfs/internal.h                         |   49 +-
>  fs/netfs/io.c                               |  657 ++++++++++
>  fs/netfs/main.c                             |   20 +
>  fs/netfs/objects.c                          |  160 +++
>  fs/netfs/read_helper.c                      | 1205 -------------------
>  fs/netfs/stats.c                            |    1 -
>  fs/nfs/fscache.c                            |    8 -
>  include/linux/fscache.h                     |   14 +
>  include/linux/netfs.h                       |  162 ++-
>  include/trace/events/cachefiles.h           |    6 +-
>  include/trace/events/netfs.h                |  190 ++-
>  35 files changed, 1867 insertions(+), 1628 deletions(-)
>  create mode 100644 fs/netfs/buffered_read.c
>  create mode 100644 fs/netfs/io.c
>  create mode 100644 fs/netfs/main.c
>  create mode 100644 fs/netfs/objects.c
>  delete mode 100644 fs/netfs/read_helper.c
> 
> 

I ran this through xfstests on ceph, with fscache enabled and it seemed
to do fine.

Tested-by: Jeff Layton <jlayton@kernel.org>
