Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B814C7324A3
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jun 2023 03:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjFPB0H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jun 2023 21:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjFPB0G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jun 2023 21:26:06 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B57AB2959
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jun 2023 18:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686878762; x=1718414762;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=DrgeiENqiXdk07vcmr4dnmGbuAnx/uqHVg2ZaCtJqE0=;
  b=malSh8Nzy4atAe6NE4KibAgrNZQeRiz3mNbtfcgC50hN3Ch6ybEyGHFi
   NwigHNtoBR2CGzd+u/4hs71ljxUSj+L+u3bAGdlDzSVAjfYFXuCiD/54N
   ttdobI7lczcLRsvEnCroKV4+QcYovQUI7A7Ddz8v1XJOKTTGbFOZQGrFC
   8NI+DOMz5M41PjKcpK5OVvm8IlaM9dUNmBWQqJjGmypLW99XCXVskLrqb
   lIEvvi8hMJJ7d3/Pon+ETgWK94Q8M1rYkxskiGTDbOTHPzgORyVQUJUJS
   KmXeK4AsaccPClsSDs5wpFsxZfFvlqDLvJ0izgTxiYaQkPSnbgw0sqqEU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="348794271"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="348794271"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 18:26:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715823733"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="715823733"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 15 Jun 2023 18:26:00 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9yDw-0000cj-05;
        Fri, 16 Jun 2023 01:26:00 +0000
Date:   Fri, 16 Jun 2023 09:25:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
Subject: [ceph-client:testing 16/22] fs/ceph/caps.c:4359:11: error: label at
 end of compound statement: expected statement
Message-ID: <202306160909.dSGgB72h-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   bfd283f9e68af7b6366532ef20f8804a0693e9d4
commit: 0c3027e76353ca86e33b4de29c8f7d8c7f127070 [16/22] ceph: issue a cap release immediately if no cap exists
config: powerpc-randconfig-r026-20230615 (https://download.01.org/0day-ci/archive/20230616/202306160909.dSGgB72h-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install powerpc cross compiling tool for clang build
        # apt-get install binutils-powerpc-linux-gnu
        # https://github.com/ceph/ceph-client/commit/0c3027e76353ca86e33b4de29c8f7d8c7f127070
        git remote add ceph-client https://github.com/ceph/ceph-client.git
        git fetch --no-tags ceph-client testing
        git checkout 0c3027e76353ca86e33b4de29c8f7d8c7f127070
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash fs/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306160909.dSGgB72h-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/ceph/caps.c:4359:11: error: label at end of compound statement: expected statement
                   default:
                           ^
                            ;
   fs/ceph/caps.c:4418:11: error: label at end of compound statement: expected statement
                   default:
                           ^
                            ;
   2 errors generated.


vim +4359 fs/ceph/caps.c

  4208	
  4209	/*
  4210	 * Handle a caps message from the MDS.
  4211	 *
  4212	 * Identify the appropriate session, inode, and call the right handler
  4213	 * based on the cap op.
  4214	 */
  4215	void ceph_handle_caps(struct ceph_mds_session *session,
  4216			      struct ceph_msg *msg)
  4217	{
  4218		struct ceph_mds_client *mdsc = session->s_mdsc;
  4219		struct inode *inode;
  4220		struct ceph_inode_info *ci;
  4221		struct ceph_cap *cap;
  4222		struct ceph_mds_caps *h;
  4223		struct ceph_mds_cap_peer *peer = NULL;
  4224		struct ceph_snap_realm *realm = NULL;
  4225		int op;
  4226		int msg_version = le16_to_cpu(msg->hdr.version);
  4227		u32 seq, mseq;
  4228		struct ceph_vino vino;
  4229		void *snaptrace;
  4230		size_t snaptrace_len;
  4231		void *p, *end;
  4232		struct cap_extra_info extra_info = {};
  4233		bool queue_trunc;
  4234		bool close_sessions = false;
  4235		bool do_cap_release = false;
  4236	
  4237		dout("handle_caps from mds%d\n", session->s_mds);
  4238	
  4239		if (!ceph_inc_mds_stopping_blocker(mdsc, session))
  4240			return;
  4241	
  4242		/* decode */
  4243		end = msg->front.iov_base + msg->front.iov_len;
  4244		if (msg->front.iov_len < sizeof(*h))
  4245			goto bad;
  4246		h = msg->front.iov_base;
  4247		op = le32_to_cpu(h->op);
  4248		vino.ino = le64_to_cpu(h->ino);
  4249		vino.snap = CEPH_NOSNAP;
  4250		seq = le32_to_cpu(h->seq);
  4251		mseq = le32_to_cpu(h->migrate_seq);
  4252	
  4253		snaptrace = h + 1;
  4254		snaptrace_len = le32_to_cpu(h->snap_trace_len);
  4255		p = snaptrace + snaptrace_len;
  4256	
  4257		if (msg_version >= 2) {
  4258			u32 flock_len;
  4259			ceph_decode_32_safe(&p, end, flock_len, bad);
  4260			if (p + flock_len > end)
  4261				goto bad;
  4262			p += flock_len;
  4263		}
  4264	
  4265		if (msg_version >= 3) {
  4266			if (op == CEPH_CAP_OP_IMPORT) {
  4267				if (p + sizeof(*peer) > end)
  4268					goto bad;
  4269				peer = p;
  4270				p += sizeof(*peer);
  4271			} else if (op == CEPH_CAP_OP_EXPORT) {
  4272				/* recorded in unused fields */
  4273				peer = (void *)&h->size;
  4274			}
  4275		}
  4276	
  4277		if (msg_version >= 4) {
  4278			ceph_decode_64_safe(&p, end, extra_info.inline_version, bad);
  4279			ceph_decode_32_safe(&p, end, extra_info.inline_len, bad);
  4280			if (p + extra_info.inline_len > end)
  4281				goto bad;
  4282			extra_info.inline_data = p;
  4283			p += extra_info.inline_len;
  4284		}
  4285	
  4286		if (msg_version >= 5) {
  4287			struct ceph_osd_client	*osdc = &mdsc->fsc->client->osdc;
  4288			u32			epoch_barrier;
  4289	
  4290			ceph_decode_32_safe(&p, end, epoch_barrier, bad);
  4291			ceph_osdc_update_epoch_barrier(osdc, epoch_barrier);
  4292		}
  4293	
  4294		if (msg_version >= 8) {
  4295			u32 pool_ns_len;
  4296	
  4297			/* version >= 6 */
  4298			ceph_decode_skip_64(&p, end, bad);	// flush_tid
  4299			/* version >= 7 */
  4300			ceph_decode_skip_32(&p, end, bad);	// caller_uid
  4301			ceph_decode_skip_32(&p, end, bad);	// caller_gid
  4302			/* version >= 8 */
  4303			ceph_decode_32_safe(&p, end, pool_ns_len, bad);
  4304			if (pool_ns_len > 0) {
  4305				ceph_decode_need(&p, end, pool_ns_len, bad);
  4306				extra_info.pool_ns =
  4307					ceph_find_or_create_string(p, pool_ns_len);
  4308				p += pool_ns_len;
  4309			}
  4310		}
  4311	
  4312		if (msg_version >= 9) {
  4313			struct ceph_timespec *btime;
  4314	
  4315			if (p + sizeof(*btime) > end)
  4316				goto bad;
  4317			btime = p;
  4318			ceph_decode_timespec64(&extra_info.btime, btime);
  4319			p += sizeof(*btime);
  4320			ceph_decode_64_safe(&p, end, extra_info.change_attr, bad);
  4321		}
  4322	
  4323		if (msg_version >= 11) {
  4324			/* version >= 10 */
  4325			ceph_decode_skip_32(&p, end, bad); // flags
  4326			/* version >= 11 */
  4327			extra_info.dirstat_valid = true;
  4328			ceph_decode_64_safe(&p, end, extra_info.nfiles, bad);
  4329			ceph_decode_64_safe(&p, end, extra_info.nsubdirs, bad);
  4330		}
  4331	
  4332		if (msg_version >= 12) {
  4333			if (parse_fscrypt_fields(&p, end, &extra_info))
  4334				goto bad;
  4335		}
  4336	
  4337		/* lookup ino */
  4338		inode = ceph_find_inode(mdsc->fsc->sb, vino);
  4339		dout(" op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op), vino.ino,
  4340		     vino.snap, inode);
  4341	
  4342		mutex_lock(&session->s_mutex);
  4343		dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
  4344		     (unsigned)seq);
  4345	
  4346		if (!inode) {
  4347			if (op == CEPH_CAP_OP_FLUSH_ACK)
  4348				pr_info("%s: can't find ino %llx:%llx for flush_ack!\n",
  4349					__func__, vino.snap, vino.ino);
  4350			else
  4351				dout(" i don't have ino %llx\n", vino.ino);
  4352	
  4353			switch (op) {
  4354			case CEPH_CAP_OP_IMPORT:
  4355			case CEPH_CAP_OP_REVOKE:
  4356			case CEPH_CAP_OP_GRANT:
  4357				do_cap_release = true;
  4358				break;
> 4359			default:
  4360			}
  4361			goto flush_cap_releases;
  4362		}
  4363		ci = ceph_inode(inode);
  4364	
  4365		/* these will work even if we don't have a cap yet */
  4366		switch (op) {
  4367		case CEPH_CAP_OP_FLUSHSNAP_ACK:
  4368			handle_cap_flushsnap_ack(inode, le64_to_cpu(msg->hdr.tid),
  4369						 h, session);
  4370			goto done;
  4371	
  4372		case CEPH_CAP_OP_EXPORT:
  4373			handle_cap_export(inode, h, peer, session);
  4374			goto done_unlocked;
  4375	
  4376		case CEPH_CAP_OP_IMPORT:
  4377			realm = NULL;
  4378			if (snaptrace_len) {
  4379				down_write(&mdsc->snap_rwsem);
  4380				if (ceph_update_snap_trace(mdsc, snaptrace,
  4381							   snaptrace + snaptrace_len,
  4382							   false, &realm)) {
  4383					up_write(&mdsc->snap_rwsem);
  4384					close_sessions = true;
  4385					goto done;
  4386				}
  4387				downgrade_write(&mdsc->snap_rwsem);
  4388			} else {
  4389				down_read(&mdsc->snap_rwsem);
  4390			}
  4391			spin_lock(&ci->i_ceph_lock);
  4392			handle_cap_import(mdsc, inode, h, peer, session,
  4393					  &cap, &extra_info.issued);
  4394			handle_cap_grant(inode, session, cap,
  4395					 h, msg->middle, &extra_info);
  4396			if (realm)
  4397				ceph_put_snap_realm(mdsc, realm);
  4398			goto done_unlocked;
  4399		}
  4400	
  4401		/* the rest require a cap */
  4402		spin_lock(&ci->i_ceph_lock);
  4403		cap = __get_cap_for_mds(ceph_inode(inode), session->s_mds);
  4404		if (!cap) {
  4405			dout(" no cap on %p ino %llx:%llx from mds%d\n",
  4406			     inode, ceph_ino(inode), ceph_snap(inode),
  4407			     session->s_mds);
  4408			spin_unlock(&ci->i_ceph_lock);
  4409			if (op == CEPH_CAP_OP_FLUSH_ACK)
  4410				pr_info("%s: no cap on %p ino %llx:%llx from mds%d for flush_ack!\n",
  4411					__func__, inode, ceph_ino(inode),
  4412					ceph_snap(inode), session->s_mds);
  4413			switch (op) {
  4414			case CEPH_CAP_OP_REVOKE:
  4415			case CEPH_CAP_OP_GRANT:
  4416				do_cap_release = true;
  4417				break;
  4418			default:
  4419			}
  4420			goto flush_cap_releases;
  4421		}
  4422	
  4423		/* note that each of these drops i_ceph_lock for us */
  4424		switch (op) {
  4425		case CEPH_CAP_OP_REVOKE:
  4426		case CEPH_CAP_OP_GRANT:
  4427			__ceph_caps_issued(ci, &extra_info.issued);
  4428			extra_info.issued |= __ceph_caps_dirty(ci);
  4429			handle_cap_grant(inode, session, cap,
  4430					 h, msg->middle, &extra_info);
  4431			goto done_unlocked;
  4432	
  4433		case CEPH_CAP_OP_FLUSH_ACK:
  4434			handle_cap_flush_ack(inode, le64_to_cpu(msg->hdr.tid),
  4435					     h, session, cap);
  4436			break;
  4437	
  4438		case CEPH_CAP_OP_TRUNC:
  4439			queue_trunc = handle_cap_trunc(inode, h, session,
  4440							&extra_info);
  4441			spin_unlock(&ci->i_ceph_lock);
  4442			if (queue_trunc)
  4443				ceph_queue_vmtruncate(inode);
  4444			break;
  4445	
  4446		default:
  4447			spin_unlock(&ci->i_ceph_lock);
  4448			pr_err("ceph_handle_caps: unknown cap op %d %s\n", op,
  4449			       ceph_cap_op_name(op));
  4450		}
  4451	
  4452	done:
  4453		mutex_unlock(&session->s_mutex);
  4454	done_unlocked:
  4455		iput(inode);
  4456	out:
  4457		ceph_dec_mds_stopping_blocker(mdsc);
  4458	
  4459		ceph_put_string(extra_info.pool_ns);
  4460	
  4461		/* Defer closing the sessions after s_mutex lock being released */
  4462		if (close_sessions)
  4463			ceph_mdsc_close_sessions(mdsc);
  4464	
  4465		kfree(extra_info.fscrypt_auth);
  4466		return;
  4467	
  4468	flush_cap_releases:
  4469		/*
  4470		 * send any cap release message to try to move things
  4471		 * along for the mds (who clearly thinks we still have this
  4472		 * cap).
  4473		 */
  4474		if (do_cap_release) {
  4475			cap = ceph_get_cap(mdsc, NULL);
  4476			cap->cap_ino = vino.ino;
  4477			cap->queue_release = 1;
  4478			cap->cap_id = le64_to_cpu(h->cap_id);
  4479			cap->mseq = mseq;
  4480			cap->seq = seq;
  4481			cap->issue_seq = seq;
  4482			spin_lock(&session->s_cap_lock);
  4483			__ceph_queue_cap_release(session, cap);
  4484			spin_unlock(&session->s_cap_lock);
  4485		}
  4486		ceph_flush_cap_releases(mdsc, session);
  4487		goto done;
  4488	
  4489	bad:
  4490		pr_err("ceph_handle_caps: corrupt message\n");
  4491		ceph_msg_dump(msg);
  4492		goto out;
  4493	}
  4494	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
