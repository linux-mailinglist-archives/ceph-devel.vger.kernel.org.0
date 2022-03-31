Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532384EE3D9
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242094AbiCaWMS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 18:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiCaWMR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 18:12:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2494C13E84
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648764629; x=1680300629;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JmYgpWBIFZ+6Fc65j5weMwUFazob/l5+/tcC1CNH0RM=;
  b=dZR7dILHapA9gd/JO5weFjn+JbBYJDBauP2A3E0lAeApo6yaBSpdJPy0
   nuoU4fkHGJirnpKd43cXuO+0IP59xt/qLELIjAmZHcsf88xVmdJSRyk/V
   3hHJhWPB42GJlCE7H6zBvMUP99ER+yiNy1qVleuxSzN+HuZ+mzs4uV1sa
   +MIkOVB2OLuol50/f/PRSBpIecwk8+/I4hp/kmRIzfZlKFuxLm6yjwusQ
   2H7TiGW40MTXH3zIMs36xqUjQRxdIyNT+dn4Zw3B6411R7mXk8mJMbrfs
   KH4bjxfmWbJ//lcq2ZhYYZpiGTyviK8qf8huBnVsO82KLz/UjSNw00Qiu
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="258805057"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="258805057"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 15:10:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="522526872"
Received: from lkp-server02.sh.intel.com (HELO 3231c491b0e2) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 31 Mar 2022 15:10:27 -0700
Received: from kbuild by 3231c491b0e2 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1na2zq-0000ge-G6;
        Thu, 31 Mar 2022 22:10:26 +0000
Date:   Fri, 1 Apr 2022 06:10:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org
Subject: [ceph-client:wip-fscrypt 38/54] fs/ceph/caps.c:3477:32: error:
 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
Message-ID: <202204010611.pgdnXxCx-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git wip-fscrypt
head:   cfa38f9d4169e3837d9a09b015492e9beb9bb8d6
commit: 1927572f5a964fa0e29bbd6fbe742c563ae66946 [38/54] ceph: handle fscrypt fields in cap messages from MDS
config: arm-buildonly-randconfig-r003-20220331 (https://download.01.org/0day-ci/archive/20220401/202204010611.pgdnXxCx-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/ceph/ceph-client/commit/1927572f5a964fa0e29bbd6fbe742c563ae66946
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client wip-fscrypt
        git checkout 1927572f5a964fa0e29bbd6fbe742c563ae66946
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash fs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/arm/include/asm/bug.h:60,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/arm/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:78,
                    from include/linux/spinlock.h:55,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from fs/ceph/caps.c:4:
   fs/ceph/caps.c: In function 'handle_cap_grant':
>> fs/ceph/caps.c:3477:32: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
    3477 |                 WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
         |                                ^~
   include/asm-generic/bug.h:166:32: note: in definition of macro 'WARN_ON'
     166 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   fs/ceph/caps.c:3477:17: note: in expansion of macro 'WARN_ON_ONCE'
    3477 |                 WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
         |                 ^~~~~~~~~~~~
>> fs/ceph/caps.c:3478:39: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth'
    3478 |                              memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
         |                                       ^~
   include/asm-generic/bug.h:166:32: note: in definition of macro 'WARN_ON'
     166 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   fs/ceph/caps.c:3477:17: note: in expansion of macro 'WARN_ON_ONCE'
    3477 |                 WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
         |                 ^~~~~~~~~~~~
   fs/ceph/caps.c:3479:40: error: 'struct ceph_inode_info' has no member named 'fscrypt_auth_len'
    3479 |                                      ci->fscrypt_auth_len));
         |                                        ^~
   include/asm-generic/bug.h:166:32: note: in definition of macro 'WARN_ON'
     166 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   fs/ceph/caps.c:3477:17: note: in expansion of macro 'WARN_ON_ONCE'
    3477 |                 WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
         |                 ^~~~~~~~~~~~


vim +3477 fs/ceph/caps.c

  3371	
  3372	/*
  3373	 * Handle a cap GRANT message from the MDS.  (Note that a GRANT may
  3374	 * actually be a revocation if it specifies a smaller cap set.)
  3375	 *
  3376	 * caller holds s_mutex and i_ceph_lock, we drop both.
  3377	 */
  3378	static void handle_cap_grant(struct inode *inode,
  3379				     struct ceph_mds_session *session,
  3380				     struct ceph_cap *cap,
  3381				     struct ceph_mds_caps *grant,
  3382				     struct ceph_buffer *xattr_buf,
  3383				     struct cap_extra_info *extra_info)
  3384		__releases(ci->i_ceph_lock)
  3385		__releases(session->s_mdsc->snap_rwsem)
  3386	{
  3387		struct ceph_inode_info *ci = ceph_inode(inode);
  3388		int seq = le32_to_cpu(grant->seq);
  3389		int newcaps = le32_to_cpu(grant->caps);
  3390		int used, wanted, dirty;
  3391		u64 size = le64_to_cpu(grant->size);
  3392		u64 max_size = le64_to_cpu(grant->max_size);
  3393		unsigned char check_caps = 0;
  3394		bool was_stale = cap->cap_gen < atomic_read(&session->s_cap_gen);
  3395		bool wake = false;
  3396		bool writeback = false;
  3397		bool queue_trunc = false;
  3398		bool queue_invalidate = false;
  3399		bool deleted_inode = false;
  3400		bool fill_inline = false;
  3401	
  3402		/*
  3403		 * If there is at least one crypto block then we'll trust fscrypt_file_size.
  3404		 * If the real length of the file is 0, then ignore it (it has probably been
  3405		 * truncated down to 0 by the MDS).
  3406		 */
  3407		if (IS_ENCRYPTED(inode) && size)
  3408			size = extra_info->fscrypt_file_size;
  3409	
  3410		dout("handle_cap_grant inode %p cap %p mds%d seq %d %s\n",
  3411		     inode, cap, session->s_mds, seq, ceph_cap_string(newcaps));
  3412		dout(" size %llu max_size %llu, i_size %llu\n", size, max_size,
  3413			i_size_read(inode));
  3414	
  3415	
  3416		/*
  3417		 * If CACHE is being revoked, and we have no dirty buffers,
  3418		 * try to invalidate (once).  (If there are dirty buffers, we
  3419		 * will invalidate _after_ writeback.)
  3420		 */
  3421		if (S_ISREG(inode->i_mode) && /* don't invalidate readdir cache */
  3422		    ((cap->issued & ~newcaps) & CEPH_CAP_FILE_CACHE) &&
  3423		    (newcaps & CEPH_CAP_FILE_LAZYIO) == 0 &&
  3424		    !(ci->i_wrbuffer_ref || ci->i_wb_ref)) {
  3425			if (try_nonblocking_invalidate(inode)) {
  3426				/* there were locked pages.. invalidate later
  3427				   in a separate thread. */
  3428				if (ci->i_rdcache_revoking != ci->i_rdcache_gen) {
  3429					queue_invalidate = true;
  3430					ci->i_rdcache_revoking = ci->i_rdcache_gen;
  3431				}
  3432			}
  3433		}
  3434	
  3435		if (was_stale)
  3436			cap->issued = cap->implemented = CEPH_CAP_PIN;
  3437	
  3438		/*
  3439		 * auth mds of the inode changed. we received the cap export message,
  3440		 * but still haven't received the cap import message. handle_cap_export
  3441		 * updated the new auth MDS' cap.
  3442		 *
  3443		 * "ceph_seq_cmp(seq, cap->seq) <= 0" means we are processing a message
  3444		 * that was sent before the cap import message. So don't remove caps.
  3445		 */
  3446		if (ceph_seq_cmp(seq, cap->seq) <= 0) {
  3447			WARN_ON(cap != ci->i_auth_cap);
  3448			WARN_ON(cap->cap_id != le64_to_cpu(grant->cap_id));
  3449			seq = cap->seq;
  3450			newcaps |= cap->issued;
  3451		}
  3452	
  3453		/* side effects now are allowed */
  3454		cap->cap_gen = atomic_read(&session->s_cap_gen);
  3455		cap->seq = seq;
  3456	
  3457		__check_cap_issue(ci, cap, newcaps);
  3458	
  3459		inode_set_max_iversion_raw(inode, extra_info->change_attr);
  3460	
  3461		if ((newcaps & CEPH_CAP_AUTH_SHARED) &&
  3462		    (extra_info->issued & CEPH_CAP_AUTH_EXCL) == 0) {
  3463			umode_t mode = le32_to_cpu(grant->mode);
  3464	
  3465			if (inode_wrong_type(inode, mode))
  3466				pr_warn_once("inode type changed! (ino %llx.%llx is 0%o, mds says 0%o)\n",
  3467					     ceph_vinop(inode), inode->i_mode, mode);
  3468			else
  3469				inode->i_mode = mode;
  3470			inode->i_uid = make_kuid(&init_user_ns, le32_to_cpu(grant->uid));
  3471			inode->i_gid = make_kgid(&init_user_ns, le32_to_cpu(grant->gid));
  3472			ci->i_btime = extra_info->btime;
  3473			dout("%p mode 0%o uid.gid %d.%d\n", inode, inode->i_mode,
  3474			     from_kuid(&init_user_ns, inode->i_uid),
  3475			     from_kgid(&init_user_ns, inode->i_gid));
  3476	
> 3477			WARN_ON_ONCE(ci->fscrypt_auth_len != extra_info->fscrypt_auth_len ||
> 3478				     memcmp(ci->fscrypt_auth, extra_info->fscrypt_auth,
  3479					     ci->fscrypt_auth_len));
  3480		}
  3481	
  3482		if ((newcaps & CEPH_CAP_LINK_SHARED) &&
  3483		    (extra_info->issued & CEPH_CAP_LINK_EXCL) == 0) {
  3484			set_nlink(inode, le32_to_cpu(grant->nlink));
  3485			if (inode->i_nlink == 0)
  3486				deleted_inode = true;
  3487		}
  3488	
  3489		if ((extra_info->issued & CEPH_CAP_XATTR_EXCL) == 0 &&
  3490		    grant->xattr_len) {
  3491			int len = le32_to_cpu(grant->xattr_len);
  3492			u64 version = le64_to_cpu(grant->xattr_version);
  3493	
  3494			if (version > ci->i_xattrs.version) {
  3495				dout(" got new xattrs v%llu on %p len %d\n",
  3496				     version, inode, len);
  3497				if (ci->i_xattrs.blob)
  3498					ceph_buffer_put(ci->i_xattrs.blob);
  3499				ci->i_xattrs.blob = ceph_buffer_get(xattr_buf);
  3500				ci->i_xattrs.version = version;
  3501				ceph_forget_all_cached_acls(inode);
  3502				ceph_security_invalidate_secctx(inode);
  3503			}
  3504		}
  3505	
  3506		if (newcaps & CEPH_CAP_ANY_RD) {
  3507			struct timespec64 mtime, atime, ctime;
  3508			/* ctime/mtime/atime? */
  3509			ceph_decode_timespec64(&mtime, &grant->mtime);
  3510			ceph_decode_timespec64(&atime, &grant->atime);
  3511			ceph_decode_timespec64(&ctime, &grant->ctime);
  3512			ceph_fill_file_time(inode, extra_info->issued,
  3513					    le32_to_cpu(grant->time_warp_seq),
  3514					    &ctime, &mtime, &atime);
  3515		}
  3516	
  3517		if ((newcaps & CEPH_CAP_FILE_SHARED) && extra_info->dirstat_valid) {
  3518			ci->i_files = extra_info->nfiles;
  3519			ci->i_subdirs = extra_info->nsubdirs;
  3520		}
  3521	
  3522		if (newcaps & (CEPH_CAP_ANY_FILE_RD | CEPH_CAP_ANY_FILE_WR)) {
  3523			/* file layout may have changed */
  3524			s64 old_pool = ci->i_layout.pool_id;
  3525			struct ceph_string *old_ns;
  3526	
  3527			ceph_file_layout_from_legacy(&ci->i_layout, &grant->layout);
  3528			old_ns = rcu_dereference_protected(ci->i_layout.pool_ns,
  3529						lockdep_is_held(&ci->i_ceph_lock));
  3530			rcu_assign_pointer(ci->i_layout.pool_ns, extra_info->pool_ns);
  3531	
  3532			if (ci->i_layout.pool_id != old_pool ||
  3533			    extra_info->pool_ns != old_ns)
  3534				ci->i_ceph_flags &= ~CEPH_I_POOL_PERM;
  3535	
  3536			extra_info->pool_ns = old_ns;
  3537	
  3538			/* size/truncate_seq? */
  3539			queue_trunc = ceph_fill_file_size(inode, extra_info->issued,
  3540						le32_to_cpu(grant->truncate_seq),
  3541						le64_to_cpu(grant->truncate_size),
  3542						size);
  3543		}
  3544	
  3545		if (ci->i_auth_cap == cap && (newcaps & CEPH_CAP_ANY_FILE_WR)) {
  3546			if (max_size != ci->i_max_size) {
  3547				dout("max_size %lld -> %llu\n",
  3548				     ci->i_max_size, max_size);
  3549				ci->i_max_size = max_size;
  3550				if (max_size >= ci->i_wanted_max_size) {
  3551					ci->i_wanted_max_size = 0;  /* reset */
  3552					ci->i_requested_max_size = 0;
  3553				}
  3554				wake = true;
  3555			}
  3556		}
  3557	
  3558		/* check cap bits */
  3559		wanted = __ceph_caps_wanted(ci);
  3560		used = __ceph_caps_used(ci);
  3561		dirty = __ceph_caps_dirty(ci);
  3562		dout(" my wanted = %s, used = %s, dirty %s\n",
  3563		     ceph_cap_string(wanted),
  3564		     ceph_cap_string(used),
  3565		     ceph_cap_string(dirty));
  3566	
  3567		if ((was_stale || le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) &&
  3568		    (wanted & ~(cap->mds_wanted | newcaps))) {
  3569			/*
  3570			 * If mds is importing cap, prior cap messages that update
  3571			 * 'wanted' may get dropped by mds (migrate seq mismatch).
  3572			 *
  3573			 * We don't send cap message to update 'wanted' if what we
  3574			 * want are already issued. If mds revokes caps, cap message
  3575			 * that releases caps also tells mds what we want. But if
  3576			 * caps got revoked by mds forcedly (session stale). We may
  3577			 * haven't told mds what we want.
  3578			 */
  3579			check_caps = 1;
  3580		}
  3581	
  3582		/* revocation, grant, or no-op? */
  3583		if (cap->issued & ~newcaps) {
  3584			int revoking = cap->issued & ~newcaps;
  3585	
  3586			dout("revocation: %s -> %s (revoking %s)\n",
  3587			     ceph_cap_string(cap->issued),
  3588			     ceph_cap_string(newcaps),
  3589			     ceph_cap_string(revoking));
  3590			if (S_ISREG(inode->i_mode) &&
  3591			    (revoking & used & CEPH_CAP_FILE_BUFFER))
  3592				writeback = true;  /* initiate writeback; will delay ack */
  3593			else if (queue_invalidate &&
  3594				 revoking == CEPH_CAP_FILE_CACHE &&
  3595				 (newcaps & CEPH_CAP_FILE_LAZYIO) == 0)
  3596				; /* do nothing yet, invalidation will be queued */
  3597			else if (cap == ci->i_auth_cap)
  3598				check_caps = 1; /* check auth cap only */
  3599			else
  3600				check_caps = 2; /* check all caps */
  3601			cap->issued = newcaps;
  3602			cap->implemented |= newcaps;
  3603		} else if (cap->issued == newcaps) {
  3604			dout("caps unchanged: %s -> %s\n",
  3605			     ceph_cap_string(cap->issued), ceph_cap_string(newcaps));
  3606		} else {
  3607			dout("grant: %s -> %s\n", ceph_cap_string(cap->issued),
  3608			     ceph_cap_string(newcaps));
  3609			/* non-auth MDS is revoking the newly grant caps ? */
  3610			if (cap == ci->i_auth_cap &&
  3611			    __ceph_caps_revoking_other(ci, cap, newcaps))
  3612			    check_caps = 2;
  3613	
  3614			cap->issued = newcaps;
  3615			cap->implemented |= newcaps; /* add bits only, to
  3616						      * avoid stepping on a
  3617						      * pending revocation */
  3618			wake = true;
  3619		}
  3620		BUG_ON(cap->issued & ~cap->implemented);
  3621	
  3622		if (extra_info->inline_version > 0 &&
  3623		    extra_info->inline_version >= ci->i_inline_version) {
  3624			ci->i_inline_version = extra_info->inline_version;
  3625			if (ci->i_inline_version != CEPH_INLINE_NONE &&
  3626			    (newcaps & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)))
  3627				fill_inline = true;
  3628		}
  3629	
  3630		if (ci->i_auth_cap == cap &&
  3631		    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
  3632			if (newcaps & ~extra_info->issued)
  3633				wake = true;
  3634	
  3635			if (ci->i_requested_max_size > max_size ||
  3636			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
  3637				/* re-request max_size if necessary */
  3638				ci->i_requested_max_size = 0;
  3639				wake = true;
  3640			}
  3641	
  3642			ceph_kick_flushing_inode_caps(session, ci);
  3643			spin_unlock(&ci->i_ceph_lock);
  3644			up_read(&session->s_mdsc->snap_rwsem);
  3645		} else {
  3646			spin_unlock(&ci->i_ceph_lock);
  3647		}
  3648	
  3649		if (fill_inline)
  3650			ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
  3651					      extra_info->inline_len);
  3652	
  3653		if (queue_trunc)
  3654			ceph_queue_vmtruncate(inode);
  3655	
  3656		if (writeback)
  3657			/*
  3658			 * queue inode for writeback: we can't actually call
  3659			 * filemap_write_and_wait, etc. from message handler
  3660			 * context.
  3661			 */
  3662			ceph_queue_writeback(inode);
  3663		if (queue_invalidate)
  3664			ceph_queue_invalidate(inode);
  3665		if (deleted_inode)
  3666			invalidate_aliases(inode);
  3667		if (wake)
  3668			wake_up_all(&ci->i_cap_wq);
  3669	
  3670		mutex_unlock(&session->s_mutex);
  3671		if (check_caps == 1)
  3672			ceph_check_caps(ci, CHECK_CAPS_AUTHONLY | CHECK_CAPS_NOINVAL,
  3673					session);
  3674		else if (check_caps == 2)
  3675			ceph_check_caps(ci, CHECK_CAPS_NOINVAL, session);
  3676	}
  3677	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
