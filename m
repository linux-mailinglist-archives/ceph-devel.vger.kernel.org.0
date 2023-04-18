Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE946E560E
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Apr 2023 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDRAxd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Apr 2023 20:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDRAxd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Apr 2023 20:53:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4585819A4
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681779171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vxNMMYZBFaGylaCyhmPo/cDBuISFxEFhh8rFLgcN6xQ=;
        b=h3sOfGGVjMYnvxkkl3BkADo9A/PpdfnTtnxVZOgHfveq7ir02u/nj7URYjeWUz6uZ4aGcc
        VMdFrYC88j5ezN2eArVqo5pIAbGtEhpVkzTp+obZsIecq7flGjhVm/O77TKQu5F6p+Z8Fe
        9iYUBHW2+2hO7ku3oCBuvkM9u4Bggvg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-IyR4HXQtMEGwCpTAfv7P9Q-1; Mon, 17 Apr 2023 20:52:50 -0400
X-MC-Unique: IyR4HXQtMEGwCpTAfv7P9Q-1
Received: by mail-pl1-f200.google.com with SMTP id a13-20020a170902eccd00b001a6be3722b7so2914894plh.6
        for <ceph-devel@vger.kernel.org>; Mon, 17 Apr 2023 17:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681779168; x=1684371168;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vxNMMYZBFaGylaCyhmPo/cDBuISFxEFhh8rFLgcN6xQ=;
        b=YhzOjx4vX8UT+SQtNkmn7BSOBU3+BodteMWFKkR3P+CsATX7j/40eptySswamTMCEI
         QJwjRlQcT3Jh+ZLUA+kzu2COlbskLAJ4M1WZsGU9J6SKxqdZsVyx9lOf46b5Y4foLmge
         Cv27pvHxnFhIPtlOcpVsGmrW0MeqcO8NPkSxbrvFe+8MBPc9TKeU96ojRtoJGzrwsxRg
         Dem7rEwVM2fN5zImMGf2lg3rqlfA6qE0+saQ2gdjeckecT+y7ohYEf8nzMhL3TGMCDPD
         PszNVCkGGD4b444Ju0ez9fCYaa+s5oj2N4jxaEzL9i4d4xRtkhRoSdnUTRgng1gZqlDK
         r8qQ==
X-Gm-Message-State: AAQBX9dO1nNyNMRt7tMS1pGFCftB+qmzdgQk8Y8ol7F4JfNwxr9PHA1d
        1M+GcKgv+CCj6jOrYlcppV1esn3q5vkvt1Foqlo5mNhVhiRdk3o6IMw66LkCU3ID9AYTuhWPBt/
        ODVZrpu1fIhmQwvFMGx/uzoj0E2Qpdjoj1ns=
X-Received: by 2002:a05:6a20:be25:b0:d9:6650:ef14 with SMTP id ge37-20020a056a20be2500b000d96650ef14mr15952097pzb.31.1681779168033;
        Mon, 17 Apr 2023 17:52:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350ap8k33HMoluyvRPZLnf8raP2nYht2Qx0IjN+y1Awiiqz0Ps0Yi/7Rdx59GAsjf309cZtGfcQ==
X-Received: by 2002:a05:6a20:be25:b0:d9:6650:ef14 with SMTP id ge37-20020a056a20be2500b000d96650ef14mr15952085pzb.31.1681779167655;
        Mon, 17 Apr 2023 17:52:47 -0700 (PDT)
Received: from [10.72.12.132] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w30-20020a63161e000000b00517f165d0a6sm7601420pgl.4.2023.04.17.17.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Apr 2023 17:52:47 -0700 (PDT)
Message-ID: <e3bc12ad-4e38-9206-bc75-e394bb2e600c@redhat.com>
Date:   Tue, 18 Apr 2023 08:52:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [ceph-client:testing 77/77] fs/ceph/mds_client.c:1866:6: warning:
 variable 'iputs' is used uninitialized whenever 'if' condition is false
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org
References: <202304172343.2ToBO5ag-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <202304172343.2ToBO5ag-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 4/17/23 23:49, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
> commit: 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d [77/77] ceph: fix potential use-after-free bug when trimming caps
> config: x86_64-randconfig-a011-20230417 (https://download.01.org/0day-ci/archive/20230417/202304172343.2ToBO5ag-lkp@intel.com/config)
> compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 3fef7c3fd10c5f078e0f6ec8c683f2d1e14eb05d
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202304172343.2ToBO5ag-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>>> fs/ceph/mds_client.c:1866:6: warning: variable 'iputs' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>             if (cap) {
>                 ^~~
>     fs/ceph/mds_client.c:1877:9: note: uninitialized use occurs here
>             while (iputs--)
>                    ^~~~~
>     fs/ceph/mds_client.c:1866:2: note: remove the 'if' if its condition is always true
>             if (cap) {
>             ^~~~~~~~~
>     fs/ceph/mds_client.c:1862:11: note: initialize the variable 'iputs' to silence this warning
>             int iputs;
>                      ^
>                       = 0
>>> fs/ceph/mds_client.c:1957:7: warning: variable 'cap' is uninitialized when used here [-Wuninitialized]
>                     if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
>                         ^~~
>     fs/ceph/mds_client.c:1949:22: note: initialize the variable 'cap' to silence this warning
>             struct ceph_cap *cap;
>                                 ^
>                                  = NULL
>     2 warnings generated.
>
>
> vim +1866 fs/ceph/mds_client.c

Thanks for reporting this.

As Luis mentioned in another thread, I will fix this in the testing branch.

- Xiubo


>
>    1855	
>    1856	static int remove_session_caps_cb(struct inode *inode, struct rb_node *ci_node,
>    1857					  void *arg)
>    1858	{
>    1859		struct ceph_inode_info *ci = ceph_inode(inode);
>    1860		bool invalidate = false;
>    1861		struct ceph_cap *cap;
>    1862		int iputs;
>    1863	
>    1864		spin_lock(&ci->i_ceph_lock);
>    1865		cap = rb_entry(ci_node, struct ceph_cap, ci_node);
>> 1866		if (cap) {
>    1867			dout(" removing cap %p, ci is %p, inode is %p\n",
>    1868			     cap, ci, &ci->netfs.inode);
>    1869	
>    1870			iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
>    1871		}
>    1872		spin_unlock(&ci->i_ceph_lock);
>    1873	
>    1874		wake_up_all(&ci->i_cap_wq);
>    1875		if (invalidate)
>    1876			ceph_queue_invalidate(inode);
>    1877		while (iputs--)
>    1878			iput(inode);
>    1879		return 0;
>    1880	}
>    1881	
>    1882	/*
>    1883	 * caller must hold session s_mutex
>    1884	 */
>    1885	static void remove_session_caps(struct ceph_mds_session *session)
>    1886	{
>    1887		struct ceph_fs_client *fsc = session->s_mdsc->fsc;
>    1888		struct super_block *sb = fsc->sb;
>    1889		LIST_HEAD(dispose);
>    1890	
>    1891		dout("remove_session_caps on %p\n", session);
>    1892		ceph_iterate_session_caps(session, remove_session_caps_cb, fsc);
>    1893	
>    1894		wake_up_all(&fsc->mdsc->cap_flushing_wq);
>    1895	
>    1896		spin_lock(&session->s_cap_lock);
>    1897		if (session->s_nr_caps > 0) {
>    1898			struct inode *inode;
>    1899			struct ceph_cap *cap, *prev = NULL;
>    1900			struct ceph_vino vino;
>    1901			/*
>    1902			 * iterate_session_caps() skips inodes that are being
>    1903			 * deleted, we need to wait until deletions are complete.
>    1904			 * __wait_on_freeing_inode() is designed for the job,
>    1905			 * but it is not exported, so use lookup inode function
>    1906			 * to access it.
>    1907			 */
>    1908			while (!list_empty(&session->s_caps)) {
>    1909				cap = list_entry(session->s_caps.next,
>    1910						 struct ceph_cap, session_caps);
>    1911				if (cap == prev)
>    1912					break;
>    1913				prev = cap;
>    1914				vino = cap->ci->i_vino;
>    1915				spin_unlock(&session->s_cap_lock);
>    1916	
>    1917				inode = ceph_find_inode(sb, vino);
>    1918				iput(inode);
>    1919	
>    1920				spin_lock(&session->s_cap_lock);
>    1921			}
>    1922		}
>    1923	
>    1924		// drop cap expires and unlock s_cap_lock
>    1925		detach_cap_releases(session, &dispose);
>    1926	
>    1927		BUG_ON(session->s_nr_caps > 0);
>    1928		BUG_ON(!list_empty(&session->s_cap_flushing));
>    1929		spin_unlock(&session->s_cap_lock);
>    1930		dispose_cap_releases(session->s_mdsc, &dispose);
>    1931	}
>    1932	
>    1933	enum {
>    1934		RECONNECT,
>    1935		RENEWCAPS,
>    1936		FORCE_RO,
>    1937	};
>    1938	
>    1939	/*
>    1940	 * wake up any threads waiting on this session's caps.  if the cap is
>    1941	 * old (didn't get renewed on the client reconnect), remove it now.
>    1942	 *
>    1943	 * caller must hold s_mutex.
>    1944	 */
>    1945	static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
>    1946	{
>    1947		struct ceph_inode_info *ci = ceph_inode(inode);
>    1948		unsigned long ev = (unsigned long)arg;
>    1949		struct ceph_cap *cap;
>    1950	
>    1951		if (ev == RECONNECT) {
>    1952			spin_lock(&ci->i_ceph_lock);
>    1953			ci->i_wanted_max_size = 0;
>    1954			ci->i_requested_max_size = 0;
>    1955			spin_unlock(&ci->i_ceph_lock);
>    1956		} else if (ev == RENEWCAPS) {
>> 1957			if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
>    1958				/* mds did not re-issue stale cap */
>    1959				spin_lock(&ci->i_ceph_lock);
>    1960				cap = rb_entry(ci_node, struct ceph_cap, ci_node);
>    1961				if (cap)
>    1962					cap->issued = cap->implemented = CEPH_CAP_PIN;
>    1963				spin_unlock(&ci->i_ceph_lock);
>    1964			}
>    1965		} else if (ev == FORCE_RO) {
>    1966		}
>    1967		wake_up_all(&ci->i_cap_wq);
>    1968		return 0;
>    1969	}
>    1970	
>

