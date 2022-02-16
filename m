Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D07C4B91CD
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Feb 2022 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbiBPTxE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Feb 2022 14:53:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiBPTxD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Feb 2022 14:53:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E473206DED
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 11:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0541CE26C0
        for <ceph-devel@vger.kernel.org>; Wed, 16 Feb 2022 19:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28A9C340E8;
        Wed, 16 Feb 2022 19:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645041167;
        bh=iVdvkGs6o+pM836ic+gfHxMTHCz3vO/zvvlWvBaTn2A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pwo465a6XrA1957AT1lpolW9mFFRNxPzRukoNTkRoPLLlCWy69Sz/YStbN3tpn7Fw
         N/Pr2mg4S8PgW848nPl9yaQnqh0Vvm7bQORcYNUkdLHfe7kdk5Vo5gl4M1YsQpQF//
         UCYYMruTYPrU+AWvilYLCdrqlQOmeiNMe1ehZyudUU9iLeU6xl5CZzB7v7UE2MareJ
         S+ZDF2GGekxj8AXMitRHsHC7WCJ4Cx8cix5HSMpOu4/2LFIbO6/TyXKMOWQA2L3oS0
         M7u9N2Mtici3cGX3xMV0oU+ehQBha/0v0+Dqug4ri703A7gHhCjJtUYwjoYE7w/ev+
         z/hK7PaOs8QSA==
Message-ID: <8d84c25fa277988b36969f1d08543aec8183d7c3.camel@kernel.org>
Subject: Re: [ceph-client:testing 13/14] fs/ceph/snap.c:438:14: warning:
 variable '_realm' is uninitialized when used here
From:   Jeff Layton <jlayton@kernel.org>
To:     kernel test robot <lkp@intel.com>, Xiubo Li <xiubli@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org
Date:   Wed, 16 Feb 2022 14:52:45 -0500
In-Reply-To: <202202170318.82LIXBXX-lkp@intel.com>
References: <202202170318.82LIXBXX-lkp@intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-02-17 at 03:33 +0800, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   91e59cfc6ca1a2bf594f60474996c71047edd1e5
> commit: 7c7e63bc9910b15ffd1f791838ff0a919058f97c [13/14] ceph: eliminate the recursion when rebuilding the snap context
> config: hexagon-randconfig-r005-20220216 (https://download.01.org/0day-ci/archive/20220217/202202170318.82LIXBXX-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0e628a783b935c70c80815db6c061ec84f884af5)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/ceph/ceph-client/commit/7c7e63bc9910b15ffd1f791838ff0a919058f97c
>         git remote add ceph-client https://github.com/ceph/ceph-client.git
>         git fetch --no-tags ceph-client testing
>         git checkout 7c7e63bc9910b15ffd1f791838ff0a919058f97c
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/ceph/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
> > > fs/ceph/snap.c:438:14: warning: variable '_realm' is uninitialized when used here [-Wuninitialized]
>                            list_del(&_realm->rebuild_item);
>                                      ^~~~~~
>    fs/ceph/snap.c:430:33: note: initialize the variable '_realm' to silence this warning
>                    struct ceph_snap_realm *_realm, *child;
>                                                  ^
>                                                   = NULL
>    1 warning generated.
> 
> 
> vim +/_realm +438 fs/ceph/snap.c
> 
>    417	
>    418	/*
>    419	 * rebuild snap context for the given realm and all of its children.
>    420	 */
>    421	static void rebuild_snap_realms(struct ceph_snap_realm *realm,
>    422					struct list_head *dirty_realms)
>    423	{
>    424		LIST_HEAD(realm_queue);
>    425		int last = 0;
>    426	
>    427		list_add_tail(&realm->rebuild_item, &realm_queue);
>    428	
>    429		while (!list_empty(&realm_queue)) {
>    430			struct ceph_snap_realm *_realm, *child;
>    431	
>    432			/*
>    433			 * If the last building failed dues to memory
>    434			 * issue, just empty the realm_queue and return
>    435			 * to avoid infinite loop.
>    436			 */
>    437			if (last < 0) {
>  > 438				list_del(&_realm->rebuild_item);
>    439				continue;
>    440			}
>    441	
>    442			_realm = list_first_entry(&realm_queue,
>    443						  struct ceph_snap_realm,
>    444						  rebuild_item);

Xiubo, I think we just need to move this assignment of _realm above the
previous if block. I've made that change in-tree. Please take a look and
make sure it looks OK to you.


>    445			last = build_snap_context(_realm, &realm_queue, dirty_realms);
>    446			dout("rebuild_snap_realms %llx %p, %s\n", _realm->ino, _realm,
>    447			     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
>    448	
>    449			list_for_each_entry(child, &_realm->children, child_item)
>    450				list_add_tail(&child->rebuild_item, &realm_queue);
>    451	
>    452			/* last == 1 means need to build parent first */
>    453			if (last <= 0)
>    454				list_del(&_realm->rebuild_item);
>    455		}
>    456	}
>    457	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Thanks, KTR!
-- 
Jeff Layton <jlayton@kernel.org>
