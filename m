Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0542E63CF6E
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 07:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233167AbiK3G73 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 01:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiK3G71 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 01:59:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5811F2D8
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669791511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NEEkvTznEEQL/xTYnIVNC36T6FLiFxYjwjwG8otpu8=;
        b=X/g7ktq0GrWDJqNgg+vxnchzIXk2XQ59851wBq7cRP1NypgRj5SO0G+b0E86do3/fwNLGU
        IdSN4ne664+B7c6npLEf7BoF6DQz5UIPGeQkE/Vwf68aPwS7VkUdCqwlsT4E6NajJ1BJPi
        VmcNiXB0gZUuPEhv5sy9g1Oyr43lAtk=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-T4qEQX9aMimdNsJgmlEpwQ-1; Wed, 30 Nov 2022 01:58:29 -0500
X-MC-Unique: T4qEQX9aMimdNsJgmlEpwQ-1
Received: by mail-pl1-f200.google.com with SMTP id t1-20020a170902b20100b001893ac9f0feso16289744plr.4
        for <ceph-devel@vger.kernel.org>; Tue, 29 Nov 2022 22:58:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3NEEkvTznEEQL/xTYnIVNC36T6FLiFxYjwjwG8otpu8=;
        b=cXHAg13t1MKJV6gjBHlRkLK+/6yxZeUpX6YKbNWdNOusoEsOuieEQnS/G/Ab+BzMfq
         Q02AacnKt427puv20YM58gwCQhsSK2nAYhS1sXK/NVYlL0++Ze+jzGlqNfHSVPGjXNHI
         K30Ew6T//YEG+8Yb7GG5Sg4USIL26EFiENM4LnLL+LAA13Ea7TuzV4a8WVVtiQDoMxfO
         v1eKsZbCLgykcfNW4V8EcUgJwu4U8i2BZafrs+OSSDRry3F4CIXfeESe8MLFN6b1ei/O
         YacqmGKCZ9D5iFzq5MDgDPMBpv8I9wTzhD71Lw1vT014pQCN1J8MHgDZ9Gwiz6B/OtLK
         LUyw==
X-Gm-Message-State: ANoB5pk3dl4IGRivWAcBkoEv1YGzT0z5fuRrhzSsfkcmnTrJAD3rGHOy
        jSqI7lTVxXT21vhN0PACdOIOLhD+NWz2KVyuYdcRLHrq5BMhPJLE42XlXWEQ5wgYGW2LDycMeer
        qLocKxRt4q8ZKXBrHmL03Y9RNosMSGzLFBXhjUuEievN38e7QSrCSnI/QBTXG9kqKS6FHmrY=
X-Received: by 2002:a17:902:f643:b0:188:9ae7:bb81 with SMTP id m3-20020a170902f64300b001889ae7bb81mr53759565plg.66.1669791508187;
        Tue, 29 Nov 2022 22:58:28 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6PVPfFJkEKj0Bkm1H/6V/6z8cCmmmRfrwrSMqWtOiJU2RzUQ+Cxj5JikQ2251CQLomOCXZ9g==
X-Received: by 2002:a17:902:f643:b0:188:9ae7:bb81 with SMTP id m3-20020a170902f64300b001889ae7bb81mr53759541plg.66.1669791507762;
        Tue, 29 Nov 2022 22:58:27 -0800 (PST)
Received: from [10.72.12.126] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s29-20020aa78bdd000000b00575b6d7c458sm627305pfd.21.2022.11.29.22.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 22:58:27 -0800 (PST)
Subject: Re: [ceph-client:testing 2/4] fs/ceph/caps.c:2967:21: error: implicit
 declaration of function 'vfs_inode_has_locks'
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
References: <202211301452.QQa0D5Kd-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <87c8b139-37a3-1d65-5e79-fabe9c69bf34@redhat.com>
Date:   Wed, 30 Nov 2022 14:58:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202211301452.QQa0D5Kd-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jeff,

Could you fix this in your vfs_inode_has_locks patch ?

We should add one dummy inline func in :

#else /* !CONFIG_FILE_LOCKING */

#endif

Currently I just added your filelock patch as one [DO NOT MERGE] in ceph 
tree for testing.

Thanks!

- Xiubo

On 30/11/2022 14:39, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   72ead199864c6617e424df714e73fde562504837
> commit: 527fba16ba73a44d115dc0521ad756c68a0ab1f6 [2/4] ceph: switch to vfs_inode_has_locks() to fix file lock bug
> config: ia64-randconfig-r015-20221130
> compiler: ia64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/527fba16ba73a44d115dc0521ad756c68a0ab1f6
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 527fba16ba73a44d115dc0521ad756c68a0ab1f6
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     fs/ceph/caps.c: In function 'ceph_get_caps':
>>> fs/ceph/caps.c:2967:21: error: implicit declaration of function 'vfs_inode_has_locks' [-Werror=implicit-function-declaration]
>      2967 |                 if (vfs_inode_has_locks(inode))
>           |                     ^~~~~~~~~~~~~~~~~~~
>     cc1: some warnings being treated as errors
>
>
> vim +/vfs_inode_has_locks +2967 fs/ceph/caps.c
>
>    2941	
>    2942	/*
>    2943	 * Wait for caps, and take cap references.  If we can't get a WR cap
>    2944	 * due to a small max_size, make sure we check_max_size (and possibly
>    2945	 * ask the mds) so we don't get hung up indefinitely.
>    2946	 */
>    2947	int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
>    2948	{
>    2949		struct ceph_file_info *fi = filp->private_data;
>    2950		struct inode *inode = file_inode(filp);
>    2951		struct ceph_inode_info *ci = ceph_inode(inode);
>    2952		struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
>    2953		int ret, _got, flags;
>    2954	
>    2955		ret = ceph_pool_perm_check(inode, need);
>    2956		if (ret < 0)
>    2957			return ret;
>    2958	
>    2959		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
>    2960		    fi->filp_gen != READ_ONCE(fsc->filp_gen))
>    2961			return -EBADF;
>    2962	
>    2963		flags = get_used_fmode(need | want);
>    2964	
>    2965		while (true) {
>    2966			flags &= CEPH_FILE_MODE_MASK;
>> 2967			if (vfs_inode_has_locks(inode))
>    2968				flags |= CHECK_FILELOCK;
>    2969			_got = 0;
>    2970			ret = try_get_cap_refs(inode, need, want, endoff,
>    2971					       flags, &_got);
>    2972			WARN_ON_ONCE(ret == -EAGAIN);
>    2973			if (!ret) {
>    2974				struct ceph_mds_client *mdsc = fsc->mdsc;
>    2975				struct cap_wait cw;
>    2976				DEFINE_WAIT_FUNC(wait, woken_wake_function);
>    2977	
>    2978				cw.ino = ceph_ino(inode);
>    2979				cw.tgid = current->tgid;
>    2980				cw.need = need;
>    2981				cw.want = want;
>    2982	
>    2983				spin_lock(&mdsc->caps_list_lock);
>    2984				list_add(&cw.list, &mdsc->cap_wait_list);
>    2985				spin_unlock(&mdsc->caps_list_lock);
>    2986	
>    2987				/* make sure used fmode not timeout */
>    2988				ceph_get_fmode(ci, flags, FMODE_WAIT_BIAS);
>    2989				add_wait_queue(&ci->i_cap_wq, &wait);
>    2990	
>    2991				flags |= NON_BLOCKING;
>    2992				while (!(ret = try_get_cap_refs(inode, need, want,
>    2993								endoff, flags, &_got))) {
>    2994					if (signal_pending(current)) {
>    2995						ret = -ERESTARTSYS;
>    2996						break;
>    2997					}
>    2998					wait_woken(&wait, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
>    2999				}
>    3000	
>    3001				remove_wait_queue(&ci->i_cap_wq, &wait);
>    3002				ceph_put_fmode(ci, flags, FMODE_WAIT_BIAS);
>    3003	
>    3004				spin_lock(&mdsc->caps_list_lock);
>    3005				list_del(&cw.list);
>    3006				spin_unlock(&mdsc->caps_list_lock);
>    3007	
>    3008				if (ret == -EAGAIN)
>    3009					continue;
>    3010			}
>    3011	
>    3012			if ((fi->fmode & CEPH_FILE_MODE_WR) &&
>    3013			    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
>    3014				if (ret >= 0 && _got)
>    3015					ceph_put_cap_refs(ci, _got);
>    3016				return -EBADF;
>    3017			}
>    3018	
>    3019			if (ret < 0) {
>    3020				if (ret == -EFBIG || ret == -EUCLEAN) {
>    3021					int ret2 = ceph_wait_on_async_create(inode);
>    3022					if (ret2 < 0)
>    3023						return ret2;
>    3024				}
>    3025				if (ret == -EFBIG) {
>    3026					check_max_size(inode, endoff);
>    3027					continue;
>    3028				}
>    3029				if (ret == -EUCLEAN) {
>    3030					/* session was killed, try renew caps */
>    3031					ret = ceph_renew_caps(inode, flags);
>    3032					if (ret == 0)
>    3033						continue;
>    3034				}
>    3035				return ret;
>    3036			}
>    3037	
>    3038			if (S_ISREG(ci->netfs.inode.i_mode) &&
>    3039			    ceph_has_inline_data(ci) &&
>    3040			    (_got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) &&
>    3041			    i_size_read(inode) > 0) {
>    3042				struct page *page =
>    3043					find_get_page(inode->i_mapping, 0);
>    3044				if (page) {
>    3045					bool uptodate = PageUptodate(page);
>    3046	
>    3047					put_page(page);
>    3048					if (uptodate)
>    3049						break;
>    3050				}
>    3051				/*
>    3052				 * drop cap refs first because getattr while
>    3053				 * holding * caps refs can cause deadlock.
>    3054				 */
>    3055				ceph_put_cap_refs(ci, _got);
>    3056				_got = 0;
>    3057	
>    3058				/*
>    3059				 * getattr request will bring inline data into
>    3060				 * page cache
>    3061				 */
>    3062				ret = __ceph_do_getattr(inode, NULL,
>    3063							CEPH_STAT_CAP_INLINE_DATA,
>    3064							true);
>    3065				if (ret < 0)
>    3066					return ret;
>    3067				continue;
>    3068			}
>    3069			break;
>    3070		}
>    3071		*got = _got;
>    3072		return 0;
>    3073	}
>    3074	
>

