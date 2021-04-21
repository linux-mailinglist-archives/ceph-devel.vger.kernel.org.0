Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165B53671AB
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Apr 2021 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242792AbhDURpv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Apr 2021 13:45:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:48304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235836AbhDURpv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 13:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 59DB4AF4F;
        Wed, 21 Apr 2021 17:45:16 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 081d005c;
        Wed, 21 Apr 2021 17:46:44 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, pdonnell@redhat.com,
        idryomov@redhat.com
Subject: Re: [PATCH v2] ceph: don't allow access to MDS-private inodes
References: <20210420140639.33705-1-jlayton@kernel.org>
        <87h7jzy5d2.fsf@suse.de>
        <2b839c9fc74107dcf4b797aef179374a34862cb2.camel@kernel.org>
Date:   Wed, 21 Apr 2021 18:46:44 +0100
In-Reply-To: <2b839c9fc74107dcf4b797aef179374a34862cb2.camel@kernel.org> (Jeff
        Layton's message of "Wed, 21 Apr 2021 12:48:52 -0400")
Message-ID: <87czuny1h7.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Wed, 2021-04-21 at 17:22 +0100, Luis Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > The MDS reserves a set of inodes for its own usage, and these should
>> > never be accessible to clients. Add a new helper to vet a proposed
>> > inode number against that range, and complain loudly and refuse to
>> > create or look it up if it's in it. We do need to carve out an exception
>> > for the root and the lost+found directories.
>> > 
>> > Also, ensure that the MDS doesn't try to delegate that range to us
>> > either. Print a warning if it does, and don't save the range in the
>> > xarray.
>> > 
>> > URL: https://tracker.ceph.com/issues/49922
>> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > Signed-off-by: Xiubo Li<xiubli@redhat.com>
>> > Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
>> > ---
>> >  fs/ceph/export.c             |  8 ++++++++
>> >  fs/ceph/inode.c              |  3 +++
>> >  fs/ceph/mds_client.c         |  7 +++++++
>> >  fs/ceph/super.h              | 24 ++++++++++++++++++++++++
>> >  include/linux/ceph/ceph_fs.h |  7 ++++---
>> >  5 files changed, 46 insertions(+), 3 deletions(-)
>> > 
>> > v2: allow lookups of lost+found dir inodes
>> >     flesh out and update the CEPH_INO_* definitions
>> > 
>> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
>> > index 17d8c8f4ec89..65540a4429b2 100644
>> > --- a/fs/ceph/export.c
>> > +++ b/fs/ceph/export.c
>> > @@ -129,6 +129,10 @@ static struct inode *__lookup_inode(struct super_block *sb, u64 ino)
>> >  
>> >  	vino.ino = ino;
>> >  	vino.snap = CEPH_NOSNAP;
>> > +
>> > +	if (ceph_vino_is_reserved(vino))
>> > +		return ERR_PTR(-ESTALE);
>> > +
>> >  	inode = ceph_find_inode(sb, vino);
>> >  	if (!inode) {
>> >  		struct ceph_mds_request *req;
>> > @@ -214,6 +218,10 @@ static struct dentry *__snapfh_to_dentry(struct super_block *sb,
>> >  		vino.ino = sfh->ino;
>> >  		vino.snap = sfh->snapid;
>> >  	}
>> > +
>> > +	if (ceph_vino_is_reserved(vino))
>> > +		return ERR_PTR(-ESTALE);
>> > +
>> >  	inode = ceph_find_inode(sb, vino);
>> >  	if (inode)
>> >  		return d_obtain_alias(inode);
>> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> > index 14a1f7963625..e1c63adb196d 100644
>> > --- a/fs/ceph/inode.c
>> > +++ b/fs/ceph/inode.c
>> > @@ -56,6 +56,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>> >  {
>> >  	struct inode *inode;
>> >  
>> > +	if (ceph_vino_is_reserved(vino))
>> > +		return ERR_PTR(-EREMOTEIO);
>> > +
>> >  	inode = iget5_locked(sb, (unsigned long)vino.ino, ceph_ino_compare,
>> >  			     ceph_set_ino_cb, &vino);
>> >  	if (!inode)
>> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> > index 63b53098360c..e5af591d3bd4 100644
>> > --- a/fs/ceph/mds_client.c
>> > +++ b/fs/ceph/mds_client.c
>> > @@ -440,6 +440,13 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>> >  
>> >  		ceph_decode_64_safe(p, end, start, bad);
>> >  		ceph_decode_64_safe(p, end, len, bad);
>> > +
>> > +		/* Don't accept a delegation of system inodes */
>> > +		if (start < CEPH_INO_SYSTEM_BASE) {
>> > +			pr_warn_ratelimited("ceph: ignoring reserved inode range delegation (start=0x%llx len=0x%llx)\n",
>> > +					start, len);
>> > +			continue;
>> > +		}
>> >  		while (len--) {
>> >  			int err = xa_insert(&s->s_delegated_inos, ino = start++,
>> >  					    DELEGATED_INO_AVAILABLE,
>> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> > index df0851b9240e..f1745403c9b0 100644
>> > --- a/fs/ceph/super.h
>> > +++ b/fs/ceph/super.h
>> > @@ -529,10 +529,34 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>> >  		ci->i_vino.snap == pvino->snap;
>> >  }
>> >  
>> > +/*
>> > + * The MDS reserves a set of inodes for its own usage. These should never
>> > + * be accessible by clients, and so the MDS has no reason to ever hand these
>> > + * out.
>> > + *
>> > + * These come from src/mds/mdstypes.h in the ceph sources.
>> > + */
>> > +#define CEPH_MAX_MDS		0x100
>> > +#define CEPH_NUM_STRAY		10
>> > +#define CEPH_INO_SYSTEM_BASE	((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
>> > +
>> > +static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>> > +{
>> > +	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
>> > +	    vino.ino != CEPH_INO_ROOT &&
>> > +	    vino.ino != CEPH_INO_LOST_AND_FOUND) {
>> > +		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
>> 
>> This warning is quite easy to hit with inode 0x3, using generic/013.  It
>> looks like, while looking for the snaprealm to check quotas, we will
>> eventually get this value from the MDS.  So this function should also
>> return 'true' if ino is CEPH_INO_GLOBAL_SNAPREALM.
>> 
>
> I wonder why I'm not seeing this. What mount options are you using?

Ah, I should have mentioned that.  I'm seeing this when using 'copyfrom'
mount option, but (and more important!) I'm also not mounting the
filesystem on the "real" root, i.e. I'm doing something like:

 mount -t ceph <ip>:<port>:/test /mnt/ ...

Not mounting on the FS root will allow us to get function
ceph_has_realms_with_quotas() to return 'true'.

For reference, I'm including the WARNING bellow.

Cheers,
-- 
Luis

[  715.628284] ------------[ cut here ]------------                                                                                                                  [72/9962]
[  715.630115] Attempt to access reserved inode number 0x3          
[  715.630208] WARNING: CPU: 0 PID: 241 at fs/ceph/super.h:549 __lookup_inode+0x238/0x250 [ceph]
[  715.635142] Modules linked in: ceph libceph       
[  715.636816] CPU: 0 PID: 241 Comm: fsstress Not tainted 5.12.0-rc4+ #141             
[  715.639317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
[  715.643873] RIP: 0010:__lookup_inode+0x238/0x250 [ceph]
[  715.646703] Code: ff ff be 03 00 00 00 48 89 ef e8 b3 3b 48 e1 eb b8 48 89 ef e8 69 38 02 00 eb ae 48 89 ee 48 c7 c7 80 e5 15 a0 e8 18 8d 92 e1 <0f> 0b eb c8 49 89 c4 e9 0
[  715.656001] RSP: 0018:ffff88812aab7680 EFLAGS: 00010286                             
[  715.658834] RAX: 0000000000000000 RBX: 1ffff11025556ed0 RCX: 0000000000000000
[  715.662373] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffed1025556ec2       
[  715.665312] RBP: 0000000000000003 R08: 0000000000000001 R09: ffffffff8363a357       
[  715.668285] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88812a3ae000
[  715.671073] R13: ffff88812a0c3200 R14: ffff88812a3ac000 R15: ffff88812b94d628
[  715.673815] FS:  00007fea04b02740(0000) GS:ffff8881f7600000(0000) knlGS:0000000000000000
[  715.676672] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                       
[  715.678782] CR2: 00007fea043ffff0 CR3: 000000012aa9a000 CR4: 00000000000006b0       
[  715.681220] Call Trace:                                                             
[  715.682112]  ? ceph_ino_compare+0x60/0x60 [ceph]                                    
[  715.683829]  ? wait_for_completion+0x170/0x170                                      
[  715.685351]  ceph_lookup_inode+0xc/0x50 [ceph]       
[  715.686997]  lookup_quotarealm_inode+0x28f/0x350 [ceph]                             
[  715.688711]  check_quota_exceeded+0x297/0x350 [ceph]                                                                                                                       
[  715.690379]  ceph_write_iter+0xd95/0x1320 [ceph]                                  
[  715.691851]  ? __lock_acquire+0x863/0x3070                                   
[  715.693100]  ? _raw_spin_unlock_irqrestore+0x2d/0x40                         
[  715.694753]  ? ceph_direct_read_write+0x1090/0x1090 [ceph]                   
[  715.696506]  ? lock_acquire+0x16d/0x4e0                                             
[  715.697748]  ? iter_file_splice_write+0x129/0x650                            
[  715.699379]  ? lock_release+0x410/0x410                                             
[  715.700486]  ? do_splice+0x5e4/0xbc0                                                                                                                                       
[  715.701659]  ? __do_splice+0x102/0x1d0                                                                                                                                     
[  715.703092]  ? __x64_sys_splice+0xcb/0x140
[  715.704638]  ? do_syscall_64+0x33/0x40
[  715.706107]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  715.708067]  ? mark_held_locks+0x65/0x90
[  715.709553]  ? lock_chain_count+0x20/0x20
[  715.711175]  ? do_iter_readv_writev+0x277/0x340
[  715.712986]  ? ceph_direct_read_write+0x1090/0x1090 [ceph]
[  715.715247]  do_iter_readv_writev+0x277/0x340
[  715.716821]  ? new_sync_write+0x370/0x370
[  715.718324]  ? lock_downgrade+0x390/0x390
[  715.719810]  do_iter_write+0xd8/0x300
[  715.720996]  ? splice_from_pipe_next.part.0+0x94/0x260
[  715.722547]  iter_file_splice_write+0x434/0x650
[  715.723737]  ? generic_splice_sendpage+0x100/0x100
[  715.725065]  ? lock_acquire+0x16d/0x4e0
[  715.726218]  ? lock_release+0x410/0x410
[  715.727386]  ? wait_for_completion+0x170/0x170
[  715.728630]  ? do_splice_to+0xcc/0x130
[  715.729777]  ? kill_fasync+0x19/0x230
[  715.730811]  ? lock_is_held_type+0x98/0x110
[  715.731934]  do_splice+0x5e4/0xbc0
[  715.732692]  ? lock_release+0x1ea/0x410
[  715.733821]  ? splice_file_to_pipe+0xd0/0xd0
[  715.734999]  ? _raw_spin_unlock+0x1f/0x30
[  715.735952]  __do_splice+0x102/0x1d0
[  715.736803]  ? do_splice+0xbc0/0xbc0
[  715.737657]  ? do_pipe2+0xe4/0x120
[  715.738313]  ? __do_pipe_flags+0xd0/0xd0
[  715.739087]  __x64_sys_splice+0xcb/0x140
[  715.739810]  do_syscall_64+0x33/0x40
[  715.740463]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  715.741418] RIP: 0033:0x7fea04c059ba
[  715.742136] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 49 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 13 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 c
[  715.745836] RSP: 002b:00007ffce6e5f948 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
[  715.747380] RAX: ffffffffffffffda RBX: 000000000000f2b2 RCX: 00007fea04c059ba
[  715.748635] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000005
[  715.749845] RBP: 0000000000000004 R08: 000000000000f2b2 R09: 0000000000000000
[  715.751046] R10: 00007ffce6e5f980 R11: 0000000000000246 R12: 000000000000f2b2
[  715.752185] R13: 0000000000000003 R14: 000000000001f91a R15: 0000000000000000
[  715.753344] irq event stamp: 202495
[  715.753945] hardirqs last  enabled at (202505): [<ffffffff8113967d>] console_unlock+0x3ed/0x720
[  715.755355] hardirqs last disabled at (202512): [<ffffffff8113980b>] console_unlock+0x57b/0x720
[  715.756738] softirqs last  enabled at (202342): [<ffffffff810a2b81>] irq_exit_rcu+0x81/0xc0
[  715.758046] softirqs last disabled at (202337): [<ffffffff810a2b81>] irq_exit_rcu+0x81/0xc0
[  715.759330] ---[ end trace 4f15801ab08eb591 ]---
