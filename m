Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF185547D25
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jun 2022 02:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiFMAu0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 12 Jun 2022 20:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiFMAuZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 12 Jun 2022 20:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F26172C3
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 17:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655081423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzh7MbU5hF0jYt2CNqara1gim4NRe9CyXFM41w1kueQ=;
        b=UkrOocD9DxPCM+o1l1wHST8/251gTPyvroPZUaSK5+2PfvPQiHCgRXd3gtYlH260hBWavM
        O30SXrUReMqIDLzMBV1lXj1a4hDxVbxcqcirCgnHEjZ2SPc6Z3d1kYZ7bkhbiPsJT4jOgJ
        srtwgsWhM9aVLumtekTn49BY1ikhE1w=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-xJ4Q6huLO8yTGPO-RPw8uQ-1; Sun, 12 Jun 2022 20:50:21 -0400
X-MC-Unique: xJ4Q6huLO8yTGPO-RPw8uQ-1
Received: by mail-pj1-f71.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so5320993pjb.2
        for <ceph-devel@vger.kernel.org>; Sun, 12 Jun 2022 17:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Bzh7MbU5hF0jYt2CNqara1gim4NRe9CyXFM41w1kueQ=;
        b=FaCgWUuKThWshiV/4ksEkT8qHAiB9ymcKDPSJ5xLFPaSdpZVdUvRnKaxTam5W4YWv9
         zxBq+spzDf9TEZU+rz9dW7GXvL04ZL3csoM52i6sjIbrZD90T94xsr41KRZK31JcABT8
         9SMOlqUD8T9XcDDKaMhl0sbkb3p3/ix42SbjAm+rWzMtm0Wr3VYNTn/SNFdYSIJkKdiC
         7d6Cw3zgHRhe+pgwmeCH/QkiJDSFRT/HhtqxTjt4ZFgmfdsI2ubfIunAsxtlmGRc8DoY
         3AgbLtKfHIKxbdVwAwVL9gVGzWSD/tkMXCXExRsqEo9MIY6eI2Vx4ymG+vwApG7VNM/Z
         fTGg==
X-Gm-Message-State: AOAM532fuube9f9oZ/zbYkOt0exjl/j4EIznRP99LsKTfSZ5UbSLB95t
        nuLCbSiDHtOKz8iL4SsDQAH1Q8i+MGUA6wkvbMZu2LmWwuOiawkXBAqVm0KbkyPlOubx8iShxdn
        bisD+Xa3//6KAisOVhCP2E9DclU6/IUzy/yxuTUIuaqCwVRGKCVXMzAZyjn4a5Cmf9LpLKjg=
X-Received: by 2002:a17:90b:4a0a:b0:1e8:5078:b574 with SMTP id kk10-20020a17090b4a0a00b001e85078b574mr12675347pjb.149.1655081420192;
        Sun, 12 Jun 2022 17:50:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy58pu7e+fmU4gaIg5kLoTJV47X2Rzvwvb1zljkZvFfbzpAb6B/hinZbHzN1jZh47hGjOF8+g==
X-Received: by 2002:a17:90b:4a0a:b0:1e8:5078:b574 with SMTP id kk10-20020a17090b4a0a00b001e85078b574mr12675317pjb.149.1655081419848;
        Sun, 12 Jun 2022 17:50:19 -0700 (PDT)
Received: from [10.72.12.41] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ij11-20020a170902ab4b00b0015e8d4eb1f9sm3625785plb.67.2022.06.12.17.50.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jun 2022 17:50:19 -0700 (PDT)
Subject: Re: [ceph-client:testing 7/14] fs/ceph/addr.c:125:2: error: call to
 undeclared function 'VM_WARN_ON_FOLIO'; ISO C99 and later do not support
 implicit function declarations
To:     kernel test robot <lkp@intel.com>, Jeff Layton <jlayton@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        ceph-devel@vger.kernel.org
References: <202206122114.9T6bqADv-lkp@intel.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8b7c8df1-df13-253b-5bfe-51c9c5c6f755@redhat.com>
Date:   Mon, 13 Jun 2022 08:50:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <202206122114.9T6bqADv-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/12/22 9:29 PM, kernel test robot wrote:
> tree:   https://github.com/ceph/ceph-client.git testing
> head:   3e303a58e3a89d254098138aa8488872bf73c9a4
> commit: 00043f493521923e81e179ef2e01a47941b07ef2 [7/14] ceph: switch back to testing for NULL folio->private in ceph_dirty_folio
> config: hexagon-randconfig-r023-20220612 (https://download.01.org/0day-ci/archive/20220612/202206122114.9T6bqADv-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 6466c9abf3674bade1f6ee859f24ebc7aaf9cd88)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/ceph/ceph-client/commit/00043f493521923e81e179ef2e01a47941b07ef2
>          git remote add ceph-client https://github.com/ceph/ceph-client.git
>          git fetch --no-tags ceph-client testing
>          git checkout 00043f493521923e81e179ef2e01a47941b07ef2
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/ceph/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>>> fs/ceph/addr.c:125:2: error: call to undeclared function 'VM_WARN_ON_FOLIO'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>             VM_WARN_ON_FOLIO(folio->private, folio);
>             ^
>     1 error generated.
>
>
> vim +/VM_WARN_ON_FOLIO +125 fs/ceph/addr.c
>
>      74	
>      75	/*
>      76	 * Dirty a page.  Optimistically adjust accounting, on the assumption
>      77	 * that we won't race with invalidate.  If we do, readjust.
>      78	 */
>      79	static bool ceph_dirty_folio(struct address_space *mapping, struct folio *folio)
>      80	{
>      81		struct inode *inode;
>      82		struct ceph_inode_info *ci;
>      83		struct ceph_snap_context *snapc;
>      84	
>      85		if (folio_test_dirty(folio)) {
>      86			dout("%p dirty_folio %p idx %lu -- already dirty\n",
>      87			     mapping->host, folio, folio->index);
>      88			VM_BUG_ON_FOLIO(!folio_test_private(folio), folio);
>      89			return false;
>      90		}
>      91	
>      92		inode = mapping->host;
>      93		ci = ceph_inode(inode);
>      94	
>      95		/* dirty the head */
>      96		spin_lock(&ci->i_ceph_lock);
>      97		BUG_ON(ci->i_wr_ref == 0); // caller should hold Fw reference
>      98		if (__ceph_have_pending_cap_snap(ci)) {
>      99			struct ceph_cap_snap *capsnap =
>     100					list_last_entry(&ci->i_cap_snaps,
>     101							struct ceph_cap_snap,
>     102							ci_item);
>     103			snapc = ceph_get_snap_context(capsnap->context);
>     104			capsnap->dirty_pages++;
>     105		} else {
>     106			BUG_ON(!ci->i_head_snapc);
>     107			snapc = ceph_get_snap_context(ci->i_head_snapc);
>     108			++ci->i_wrbuffer_ref_head;
>     109		}
>     110		if (ci->i_wrbuffer_ref == 0)
>     111			ihold(inode);
>     112		++ci->i_wrbuffer_ref;
>     113		dout("%p dirty_folio %p idx %lu head %d/%d -> %d/%d "
>     114		     "snapc %p seq %lld (%d snaps)\n",
>     115		     mapping->host, folio, folio->index,
>     116		     ci->i_wrbuffer_ref-1, ci->i_wrbuffer_ref_head-1,
>     117		     ci->i_wrbuffer_ref, ci->i_wrbuffer_ref_head,
>     118		     snapc, snapc->seq, snapc->num_snaps);
>     119		spin_unlock(&ci->i_ceph_lock);
>     120	
>     121		/*
>     122		 * Reference snap context in folio->private.  Also set
>     123		 * PagePrivate so that we get invalidate_folio callback.
>     124		 */
>   > 125		VM_WARN_ON_FOLIO(folio->private, folio);

Thanks for the report, I have fixed it by defining the VM_WARN_ON_FOLIO 
macro in case the DEBUG_VM is disabled.

-- Xiubo


>     126		folio_attach_private(folio, snapc);
>     127	
>     128		return ceph_fscache_dirty_folio(mapping, folio);
>     129	}
>     130	
>

