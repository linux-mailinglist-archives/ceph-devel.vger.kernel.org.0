Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F38730CFA
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jun 2023 04:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbjFOCBU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jun 2023 22:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjFOCBT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 14 Jun 2023 22:01:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AD3198D
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 19:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686794429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dEW2WuzUEff2tWnozM9SWRMkdV3YQREMWTz0R/b+9e4=;
        b=FBucOmGTIMECzSPu4T8i3v6zbR0GWFuNnbm4RhClo2qKWyInQslZcJb1jmtO8keVVfdEgD
        l0tz59AgZuDTygIwXXEkRYNzBFd+c67mwvDa04VW+yIGHaL9NuH0J+VtIhxr0lnCyxINxt
        dyQ1KENHYZ7VZR9DZdY02jnGG8dVwXo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-xSYmjidtN-Cjrtsp9Nku_g-1; Wed, 14 Jun 2023 22:00:11 -0400
X-MC-Unique: xSYmjidtN-Cjrtsp9Nku_g-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b3e18add74so17737125ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jun 2023 19:00:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686794411; x=1689386411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dEW2WuzUEff2tWnozM9SWRMkdV3YQREMWTz0R/b+9e4=;
        b=NrCWUbM4EUNWxY2ss6akD0JPfMySDKevgKW4O65UgWy52ddlyMYy8H85JQYY6JoHNk
         JqIUadMVIZQp0/rt4v8VZLsjKxUbwO0OlFPUT7y+5w0idXEE4AJEOtE9375aabAIqQTH
         x1Em0u2vBCkIr8rm+yL3V/8A/GK0PeBtPv/P462fgQmEmICdwXzhhnMglbHMkbAcDXS1
         VpYd57S/sAwWVBIk8mkLVF2/FhXWrx13URqLoOrsli7LnP1MY/jhIPPsvFb0MqWKQwtn
         6+Zh1ELhRHu1d9A7TfJ7rQjY+VbGb1UXESKnJGBMgNG3n2dab/Uxl1PsL4Ee9jbVrJd5
         f4dA==
X-Gm-Message-State: AC+VfDyT0wrGWc73iDv+XeYTmhuPoMQB39TZg7/2M9f8A2bXvnVGXyVf
        YnpXIkjdMiKCzbPTstzacCj4rK0gt8F6JvTZvNa8EmceE2Vss+UziOoqYWd8JDO0nAGuKb82owp
        y0amOrIuguAcY9im5jvQyYg==
X-Received: by 2002:a17:902:e884:b0:1b5:16f2:a4e3 with SMTP id w4-20020a170902e88400b001b516f2a4e3mr467064plg.30.1686794410643;
        Wed, 14 Jun 2023 19:00:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yU5RCXDCcZibNkPoMN6bbVrC2s9pJKemHwR3igK/OhMXcgxw12xr+CNxVrf37zMY2UuH7bw==
X-Received: by 2002:a17:902:e884:b0:1b5:16f2:a4e3 with SMTP id w4-20020a170902e88400b001b516f2a4e3mr467020plg.30.1686794408789;
        Wed, 14 Jun 2023 19:00:08 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x8-20020a1709027c0800b001ab39cd875csm12756341pll.133.2023.06.14.19.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 19:00:07 -0700 (PDT)
Message-ID: <e257d4d9-6e0d-1667-d7b6-8e070aeb8a7b@redhat.com>
Date:   Thu, 15 Jun 2023 10:00:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [ceph-client:testing 21/21] fs/ceph/file.c:24:29: warning: unused
 variable 'cl'
Content-Language: en-US
To:     kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
References: <202306142255.ny5wITLE-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <202306142255.ny5wITLE-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks for reporting this.

This will be seen when 'CONFIG_CEPH_LIB_PRETTYDEBUG=y' and 'DEBUG' not 
set and 'CONFIG_DYNAMIC_DEBUG' also not set.

Locally I was planing to build it with these options, will fix it.

Thanks

- XIubo

On 6/14/23 22:07, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   363520bbbed48e045504a785c8af582e7533a115
> commit: 363520bbbed48e045504a785c8af582e7533a115 [21/21] ceph: print the client global_id in all the debug logs
> config: i386-randconfig-i011-20230612 (https://download.01.org/0day-ci/archive/20230614/202306142255.ny5wITLE-lkp@intel.com/config)
> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
> reproduce (this is a W=1 build):
>          # https://github.com/ceph/ceph-client/commit/363520bbbed48e045504a785c8af582e7533a115
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 363520bbbed48e045504a785c8af582e7533a115
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          make W=1 O=build_dir ARCH=i386 olddefconfig
>          make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/ceph/
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202306142255.ny5wITLE-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>     fs/ceph/file.c: In function 'ceph_flags_sys2wire':
>>> fs/ceph/file.c:24:29: warning: unused variable 'cl' [-Wunused-variable]
>        24 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_init_file_info':
>     fs/ceph/file.c:205:29: warning: unused variable 'cl' [-Wunused-variable]
>       205 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_init_file':
>     fs/ceph/file.c:264:29: warning: unused variable 'cl' [-Wunused-variable]
>       264 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_renew_caps':
>     fs/ceph/file.c:302:29: warning: unused variable 'cl' [-Wunused-variable]
>       302 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_open':
>     fs/ceph/file.c:363:29: warning: unused variable 'cl' [-Wunused-variable]
>       363 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_finish_async_create':
>     fs/ceph/file.c:644:29: warning: unused variable 'cl' [-Wunused-variable]
>       644 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_release':
>     fs/ceph/file.c:930:29: warning: unused variable 'cl' [-Wunused-variable]
>       930 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function '__ceph_sync_read':
>     fs/ceph/file.c:985:29: warning: unused variable 'cl' [-Wunused-variable]
>       985 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_sync_read':
>     fs/ceph/file.c:1183:29: warning: unused variable 'cl' [-Wunused-variable]
>      1183 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_aio_complete':
>     fs/ceph/file.c:1215:29: warning: unused variable 'cl' [-Wunused-variable]
>      1215 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_aio_complete_req':
>     fs/ceph/file.c:1268:29: warning: unused variable 'cl' [-Wunused-variable]
>      1268 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_direct_read_write':
>     fs/ceph/file.c:1415:29: warning: unused variable 'cl' [-Wunused-variable]
>      1415 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_sync_write':
>     fs/ceph/file.c:1642:29: warning: unused variable 'cl' [-Wunused-variable]
>      1642 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_read_iter':
>     fs/ceph/file.c:2043:29: warning: unused variable 'cl' [-Wunused-variable]
>      2043 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_write_iter':
>     fs/ceph/file.c:2204:29: warning: unused variable 'cl' [-Wunused-variable]
>      2204 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/file.c: In function 'ceph_fallocate':
>     fs/ceph/file.c:2537:29: warning: unused variable 'cl' [-Wunused-variable]
>      2537 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/file.c: In function 'is_file_size_ok':
>     fs/ceph/file.c:2674:29: warning: unused variable 'cl' [-Wunused-variable]
>      2674 |         struct ceph_client *cl = ceph_inode_to_client(src_inode);
>           |                             ^~
>     fs/ceph/file.c: In function '__ceph_copy_file_range':
>     fs/ceph/file.c:2834:29: warning: unused variable 'cl' [-Wunused-variable]
>      2834 |         struct ceph_client *cl = src_fsc->client;
>           |                             ^~
> --
>     fs/ceph/caps.c: In function 'ceph_unreserve_caps':
>>> fs/ceph/caps.c:311:29: warning: unused variable 'cl' [-Wunused-variable]
>       311 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_get_cap':
>     fs/ceph/caps.c:333:29: warning: unused variable 'cl' [-Wunused-variable]
>       333 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_put_cap':
>     fs/ceph/caps.c:388:29: warning: unused variable 'cl' [-Wunused-variable]
>       388 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function '__check_cap_issue':
>     fs/ceph/caps.c:582:29: warning: unused variable 'cl' [-Wunused-variable]
>       582 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_add_cap':
>     fs/ceph/caps.c:658:29: warning: unused variable 'cl' [-Wunused-variable]
>       658 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function '__cap_is_valid':
>     fs/ceph/caps.c:791:29: warning: unused variable 'cl' [-Wunused-variable]
>       791 |         struct ceph_client *cl = cap->session->s_mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function '__ceph_caps_issued':
>     fs/ceph/caps.c:816:29: warning: unused variable 'cl' [-Wunused-variable]
>       816 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function '__touch_cap':
>     fs/ceph/caps.c:874:29: warning: unused variable 'cl' [-Wunused-variable]
>       874 |         struct ceph_client *cl = s->s_mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function '__ceph_caps_issued_mask':
>     fs/ceph/caps.c:896:29: warning: unused variable 'cl' [-Wunused-variable]
>       896 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_caps_revoking':
>     fs/ceph/caps.c:986:29: warning: unused variable 'cl' [-Wunused-variable]
>       986 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function '__ceph_remove_cap':
>     fs/ceph/caps.c:1140:29: warning: unused variable 'cl' [-Wunused-variable]
>      1140 |         struct ceph_client *cl = session->s_mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function '__prep_cap':
>     fs/ceph/caps.c:1412:29: warning: unused variable 'cl' [-Wunused-variable]
>      1412 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_flush_snaps':
>     fs/ceph/caps.c:1735:29: warning: unused variable 'cl' [-Wunused-variable]
>      1735 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function '__mark_caps_flushing':
>     fs/ceph/caps.c:1927:29: warning: unused variable 'cl' [-Wunused-variable]
>      1927 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'try_nonblocking_invalidate':
>     fs/ceph/caps.c:1976:29: warning: unused variable 'cl' [-Wunused-variable]
>      1976 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_check_caps':
>     fs/ceph/caps.c:2026:29: warning: unused variable 'cl' [-Wunused-variable]
>      2026 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'flush_mdlog_and_wait_inode_unsafe_requests':
>     fs/ceph/caps.c:2369:29: warning: unused variable 'cl' [-Wunused-variable]
>      2369 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_fsync':
>     fs/ceph/caps.c:2487:29: warning: unused variable 'cl' [-Wunused-variable]
>      2487 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_write_inode':
>     fs/ceph/caps.c:2539:29: warning: unused variable 'cl' [-Wunused-variable]
>      2539 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_take_cap_refs':
>     fs/ceph/caps.c:2773:29: warning: unused variable 'cl' [-Wunused-variable]
>      2773 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'try_get_cap_refs':
>     fs/ceph/caps.c:2827:29: warning: unused variable 'cl' [-Wunused-variable]
>      2827 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'check_max_size':
>     fs/ceph/caps.c:2989:29: warning: unused variable 'cl' [-Wunused-variable]
>      2989 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_try_drop_cap_snap':
>     fs/ceph/caps.c:3206:29: warning: unused variable 'cl' [-Wunused-variable]
>      3206 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function '__ceph_put_cap_refs':
>     fs/ceph/caps.c:3242:29: warning: unused variable 'cl' [-Wunused-variable]
>      3242 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_put_wrbuffer_cap_refs':
>     fs/ceph/caps.c:3358:29: warning: unused variable 'cl' [-Wunused-variable]
>      3358 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'invalidate_aliases':
>     fs/ceph/caps.c:3443:29: warning: unused variable 'cl' [-Wunused-variable]
>      3443 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'handle_cap_flush_ack':
>     fs/ceph/caps.c:3819:29: warning: unused variable 'cl' [-Wunused-variable]
>      3819 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function '__ceph_remove_capsnap':
>     fs/ceph/caps.c:3934:29: warning: unused variable 'cl' [-Wunused-variable]
>      3934 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'handle_cap_flushsnap_ack':
>     fs/ceph/caps.c:3980:29: warning: unused variable 'cl' [-Wunused-variable]
>      3980 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'handle_cap_trunc':
>     fs/ceph/caps.c:4032:29: warning: unused variable 'cl' [-Wunused-variable]
>      4032 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_check_delayed_caps':
>     fs/ceph/caps.c:4604:29: warning: unused variable 'cl' [-Wunused-variable]
>      4604 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'flush_dirty_session_caps':
>     fs/ceph/caps.c:4650:29: warning: unused variable 'cl' [-Wunused-variable]
>      4650 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_encode_inode_release':
>     fs/ceph/caps.c:4794:29: warning: unused variable 'cl' [-Wunused-variable]
>      4794 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/caps.c: In function 'ceph_encode_dentry_release':
>>> fs/ceph/caps.c:4888:29: warning: variable 'cl' set but not used [-Wunused-but-set-variable]
>      4888 |         struct ceph_client *cl;
>           |                             ^~
>     fs/ceph/caps.c: In function 'remove_capsnaps':
>     fs/ceph/caps.c:4940:29: warning: unused variable 'cl' [-Wunused-variable]
>      4940 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
> --
>     fs/ceph/inode.c: In function 'ceph_get_inode':
>>> fs/ceph/inode.c:132:29: warning: unused variable 'cl' [-Wunused-variable]
>       132 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
>     fs/ceph/inode.c: In function '__get_or_create_frag':
>     fs/ceph/inode.c:257:29: warning: unused variable 'cl' [-Wunused-variable]
>       257 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function '__ceph_choose_frag':
>     fs/ceph/inode.c:322:29: warning: unused variable 'cl' [-Wunused-variable]
>       322 |         struct ceph_client *cl = ceph_inode_to_client(&ci->netfs.inode);
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_alloc_inode':
>>> fs/ceph/inode.c:568:32: warning: unused variable 'fsc' [-Wunused-variable]
>       568 |         struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
>           |                                ^~~
>     fs/ceph/inode.c: In function 'ceph_evict_inode':
>     fs/ceph/inode.c:691:29: warning: unused variable 'cl' [-Wunused-variable]
>       691 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_fill_file_time':
>     fs/ceph/inode.c:849:29: warning: unused variable 'cl' [-Wunused-variable]
>       849 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function '__update_dentry_lease':
>     fs/ceph/inode.c:1366:29: warning: unused variable 'cl' [-Wunused-variable]
>      1366 |         struct ceph_client *cl = ceph_inode_to_client(dir);
>           |                             ^~
>     fs/ceph/inode.c: In function 'fill_readdir_cache':
>     fs/ceph/inode.c:1884:29: warning: unused variable 'cl' [-Wunused-variable]
>      1884 |         struct ceph_client *cl = ceph_inode_to_client(dir);
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_inode_set_size':
>     fs/ceph/inode.c:2123:29: warning: unused variable 'cl' [-Wunused-variable]
>      2123 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_queue_inode_work':
>     fs/ceph/inode.c:2144:29: warning: unused variable 'cl' [-Wunused-variable]
>      2144 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/inode.c: In function '__ceph_do_pending_vmtruncate':
>     fs/ceph/inode.c:2226:29: warning: unused variable 'cl' [-Wunused-variable]
>      2226 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_inode_work':
>     fs/ceph/inode.c:2289:29: warning: unused variable 'cl' [-Wunused-variable]
>      2289 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function 'fill_fscrypt_truncate':
>     fs/ceph/inode.c:2362:29: warning: unused variable 'cl' [-Wunused-variable]
>      2362 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function '__ceph_setattr':
>     fs/ceph/inode.c:2497:29: warning: unused variable 'cl' [-Wunused-variable]
>      2497 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/inode.c: In function '__ceph_do_getattr':
>     fs/ceph/inode.c:2892:29: warning: unused variable 'cl' [-Wunused-variable]
>      2892 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/inode.c: In function 'ceph_do_getvxattr':
>     fs/ceph/inode.c:2940:29: warning: unused variable 'cl' [-Wunused-variable]
>      2940 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
> --
>     fs/ceph/quota.c: In function 'lookup_quotarealm_inode':
>>> fs/ceph/quota.c:134:29: warning: unused variable 'cl' [-Wunused-variable]
>       134 |         struct ceph_client *cl = mdsc->fsc->client;
>           |                             ^~
> --
>     fs/ceph/addr.c: In function 'ceph_dirty_folio':
>>> fs/ceph/addr.c:83:29: warning: unused variable 'cl' [-Wunused-variable]
>        83 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_invalidate_folio':
>     fs/ceph/addr.c:141:29: warning: unused variable 'cl' [-Wunused-variable]
>       141 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_release_folio':
>     fs/ceph/addr.c:168:29: warning: unused variable 'cl' [-Wunused-variable]
>       168 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'finish_netfs_read':
>     fs/ceph/addr.c:247:29: warning: unused variable 'cl' [-Wunused-variable]
>       247 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_netfs_issue_read':
>     fs/ceph/addr.c:351:29: warning: unused variable 'cl' [-Wunused-variable]
>       351 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_init_request':
>     fs/ceph/addr.c:438:29: warning: unused variable 'cl' [-Wunused-variable]
>       438 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'get_oldest_context':
>     fs/ceph/addr.c:568:29: warning: unused variable 'cl' [-Wunused-variable]
>       568 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'writepage_nounlock':
>     fs/ceph/addr.c:665:29: warning: unused variable 'cl' [-Wunused-variable]
>       665 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_find_incompatible':
>     fs/ceph/addr.c:1449:29: warning: unused variable 'cl' [-Wunused-variable]
>      1449 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_write_end':
>     fs/ceph/addr.c:1554:29: warning: unused variable 'cl' [-Wunused-variable]
>      1554 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_filemap_fault':
>     fs/ceph/addr.c:1619:29: warning: unused variable 'cl' [-Wunused-variable]
>      1619 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_page_mkwrite':
>     fs/ceph/addr.c:1709:29: warning: unused variable 'cl' [-Wunused-variable]
>      1709 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_fill_inline_data':
>     fs/ceph/addr.c:1812:29: warning: unused variable 'cl' [-Wunused-variable]
>      1812 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_uninline_data':
>     fs/ceph/addr.c:1859:29: warning: unused variable 'cl' [-Wunused-variable]
>      1859 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/addr.c: In function '__ceph_pool_perm_get':
>     fs/ceph/addr.c:2015:29: warning: unused variable 'cl' [-Wunused-variable]
>      2015 |         struct ceph_client *cl = fsc->client;
>           |                             ^~
>     fs/ceph/addr.c: In function 'ceph_pool_perm_check':
>     fs/ceph/addr.c:2187:29: warning: unused variable 'cl' [-Wunused-variable]
>      2187 |         struct ceph_client *cl = ceph_inode_to_client(inode);
>           |                             ^~
> ..
>
>
> vim +/cl +24 fs/ceph/file.c
>
>      21	
>      22	static __le32 ceph_flags_sys2wire(struct ceph_mds_client *mdsc, u32 flags)
>      23	{
>    > 24		struct ceph_client *cl = mdsc->fsc->client;
>      25		u32 wire_flags = 0;
>      26	
>      27		switch (flags & O_ACCMODE) {
>      28		case O_RDONLY:
>      29			wire_flags |= CEPH_O_RDONLY;
>      30			break;
>      31		case O_WRONLY:
>      32			wire_flags |= CEPH_O_WRONLY;
>      33			break;
>      34		case O_RDWR:
>      35			wire_flags |= CEPH_O_RDWR;
>      36			break;
>      37		}
>      38	
>      39		flags &= ~O_ACCMODE;
>      40	
>

