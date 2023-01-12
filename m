Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734B2666A61
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Jan 2023 05:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbjALEhn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Jan 2023 23:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbjALEhl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Jan 2023 23:37:41 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C476319C2E
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 20:37:37 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id z8-20020a05600c220800b003d33b0bda11so3466442wml.0
        for <ceph-devel@vger.kernel.org>; Wed, 11 Jan 2023 20:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ikWUc5JgWpS2s/hPMUFfPIbzMPePYVPg31Zosf85nYQ=;
        b=NZJo1odYk/5D4fsIYwVxcX3afVxPiAOzks9xXVt7AArMB0xlMtu+Vszm1aWEehdVzt
         aZ74vWIB7PbqEnkZbCm4A0kGMQZXxCGrqRr/onfY/5fMl9v8lwTRMVyhq6jve/JXXFrC
         6iBGm5iY5T4jQr6+t+GpyB9zKVzXmtccLgDrnhwO08/8DSRx/NA4ldBJIoNKLSE2kyxe
         LIBMzTdNAyUz4TFg+cpXH4uzh5leiQURvtTuqm3LQqjao4V4/7+oDUY+melaCzFjvQHh
         xdXSjOovFWPVX6stCuaFaZoOL1DVQCuUha8+pwXv9I0nFn5FlmLH/Fit7WfwCUt4SEtx
         ofNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ikWUc5JgWpS2s/hPMUFfPIbzMPePYVPg31Zosf85nYQ=;
        b=sS8POdmRnQPiknOCxdYXpI6JErJEV+2V4FJPyfLFFldZw9JVktob0Zwz8cDRJ/uuUT
         DXmEsUhmLQ2dIMTVGPwES5HoOXnUsSe+pA23fzMB1kIpaKSrhTi1v93/JjMaXygfiLRf
         4JWaMlbTD4B44z1t7sk+PYKf5lfuOvB37uCfw8q6F8+WIQo3ryfF5QO0+TWqsWi1Jjxg
         WzudHGsmsm9IhiB9W3rIcAPjQWwt6xM54QK61fgYiPuZPuHGiTEeJ90+fJLeHoJzm55I
         d1r2p2BQeRzKLoty1E7VI+woy3tfpFKwx8Rc85gzw/ML5s+qab+Oufu0Ul/JB5/VldRr
         +xqw==
X-Gm-Message-State: AFqh2krw1UTT1tg7wMIYHDK9KoqvMQeJPlchFc+U6gKdDMLEiB9Dg8yZ
        Pv33bEMnPt7p0hqfUrFNwd8C5Gn7/C8=
X-Google-Smtp-Source: AMrXdXs1OD+SfjgcAomGie0UzVdmd543VBV8yimZGH1gBNhOG5HkZzOuY+KJG+i7hLeIoenekaDHSg==
X-Received: by 2002:a05:600c:2247:b0:3d3:4b1a:6ff9 with SMTP id a7-20020a05600c224700b003d34b1a6ff9mr54720326wmm.26.1673498256200;
        Wed, 11 Jan 2023 20:37:36 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q6-20020a05600c46c600b003d1f3e9df3csm26820851wmo.7.2023.01.11.20.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 20:37:35 -0800 (PST)
Date:   Thu, 12 Jan 2023 07:37:32 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Jeff Layton <jlayton@kernel.org>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>
Subject: [ceph-client:testing 17/77] fs/ceph/mds_client.c:218
 parse_reply_info_in() warn: missing unwind goto?
Message-ID: <202301120708.Xouvfbeb-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

tree:   https://github.com/ceph/ceph-client.git testing
head:   dd9ed6e7fed7f133e63ecadd3ea5b1140221df0b
commit: d77b55b952a06f69cec796b9f675165d8aa6275d [17/77] ceph: fscrypt_auth handling for ceph
config: parisc-randconfig-m031-20230110
compiler: hppa-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>

New smatch warnings:
fs/ceph/mds_client.c:218 parse_reply_info_in() warn: missing unwind goto?

vim +218 fs/ceph/mds_client.c

2f2dc053404feb Sage Weil        2009-10-06  100  static int parse_reply_info_in(void **p, void *end,
14303d20f3ae3e Sage Weil        2010-12-14  101  			       struct ceph_mds_reply_info_in *info,
12b4629a9fb80f Ilya Dryomov     2013-12-24  102  			       u64 features)
2f2dc053404feb Sage Weil        2009-10-06  103  {
b37fe1f923fb4b Yan, Zheng       2019-01-09  104  	int err = 0;
b37fe1f923fb4b Yan, Zheng       2019-01-09  105  	u8 struct_v = 0;
b37fe1f923fb4b Yan, Zheng       2019-01-09  106  
b37fe1f923fb4b Yan, Zheng       2019-01-09  107  	if (features == (u64)-1) {
b37fe1f923fb4b Yan, Zheng       2019-01-09  108  		u32 struct_len;
b37fe1f923fb4b Yan, Zheng       2019-01-09  109  		u8 struct_compat;
b37fe1f923fb4b Yan, Zheng       2019-01-09  110  		ceph_decode_8_safe(p, end, struct_v, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  111  		ceph_decode_8_safe(p, end, struct_compat, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  112  		/* struct_v is expected to be >= 1. we only understand
b37fe1f923fb4b Yan, Zheng       2019-01-09  113  		 * encoding with struct_compat == 1. */
b37fe1f923fb4b Yan, Zheng       2019-01-09  114  		if (!struct_v || struct_compat != 1)
b37fe1f923fb4b Yan, Zheng       2019-01-09  115  			goto bad;
b37fe1f923fb4b Yan, Zheng       2019-01-09  116  		ceph_decode_32_safe(p, end, struct_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  117  		ceph_decode_need(p, end, struct_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  118  		end = *p + struct_len;
b37fe1f923fb4b Yan, Zheng       2019-01-09  119  	}
2f2dc053404feb Sage Weil        2009-10-06  120  
b37fe1f923fb4b Yan, Zheng       2019-01-09  121  	ceph_decode_need(p, end, sizeof(struct ceph_mds_reply_inode), bad);
2f2dc053404feb Sage Weil        2009-10-06  122  	info->in = *p;
2f2dc053404feb Sage Weil        2009-10-06  123  	*p += sizeof(struct ceph_mds_reply_inode) +
2f2dc053404feb Sage Weil        2009-10-06  124  		sizeof(*info->in->fragtree.splits) *
2f2dc053404feb Sage Weil        2009-10-06  125  		le32_to_cpu(info->in->fragtree.nsplits);
2f2dc053404feb Sage Weil        2009-10-06  126  
2f2dc053404feb Sage Weil        2009-10-06  127  	ceph_decode_32_safe(p, end, info->symlink_len, bad);
2f2dc053404feb Sage Weil        2009-10-06  128  	ceph_decode_need(p, end, info->symlink_len, bad);
2f2dc053404feb Sage Weil        2009-10-06  129  	info->symlink = *p;
2f2dc053404feb Sage Weil        2009-10-06  130  	*p += info->symlink_len;
2f2dc053404feb Sage Weil        2009-10-06  131  
14303d20f3ae3e Sage Weil        2010-12-14  132  	ceph_decode_copy_safe(p, end, &info->dir_layout,
14303d20f3ae3e Sage Weil        2010-12-14  133  			      sizeof(info->dir_layout), bad);
2f2dc053404feb Sage Weil        2009-10-06  134  	ceph_decode_32_safe(p, end, info->xattr_len, bad);
2f2dc053404feb Sage Weil        2009-10-06  135  	ceph_decode_need(p, end, info->xattr_len, bad);
2f2dc053404feb Sage Weil        2009-10-06  136  	info->xattr_data = *p;
2f2dc053404feb Sage Weil        2009-10-06  137  	*p += info->xattr_len;
fb01d1f8b0343f Yan, Zheng       2014-11-14  138  
b37fe1f923fb4b Yan, Zheng       2019-01-09  139  	if (features == (u64)-1) {
b37fe1f923fb4b Yan, Zheng       2019-01-09  140  		/* inline data */
b37fe1f923fb4b Yan, Zheng       2019-01-09  141  		ceph_decode_64_safe(p, end, info->inline_version, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  142  		ceph_decode_32_safe(p, end, info->inline_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  143  		ceph_decode_need(p, end, info->inline_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  144  		info->inline_data = *p;
b37fe1f923fb4b Yan, Zheng       2019-01-09  145  		*p += info->inline_len;
b37fe1f923fb4b Yan, Zheng       2019-01-09  146  		/* quota */
b37fe1f923fb4b Yan, Zheng       2019-01-09  147  		err = parse_reply_info_quota(p, end, info);
b37fe1f923fb4b Yan, Zheng       2019-01-09  148  		if (err < 0)
b37fe1f923fb4b Yan, Zheng       2019-01-09  149  			goto out_bad;
                                                                        ^^^^^^^^^^^^


b37fe1f923fb4b Yan, Zheng       2019-01-09  150  		/* pool namespace */
b37fe1f923fb4b Yan, Zheng       2019-01-09  151  		ceph_decode_32_safe(p, end, info->pool_ns_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  152  		if (info->pool_ns_len > 0) {
b37fe1f923fb4b Yan, Zheng       2019-01-09  153  			ceph_decode_need(p, end, info->pool_ns_len, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  154  			info->pool_ns_data = *p;
b37fe1f923fb4b Yan, Zheng       2019-01-09  155  			*p += info->pool_ns_len;
b37fe1f923fb4b Yan, Zheng       2019-01-09  156  		}
245ce991cca55e Jeff Layton      2019-05-29  157  
245ce991cca55e Jeff Layton      2019-05-29  158  		/* btime */
245ce991cca55e Jeff Layton      2019-05-29  159  		ceph_decode_need(p, end, sizeof(info->btime), bad);
245ce991cca55e Jeff Layton      2019-05-29  160  		ceph_decode_copy(p, &info->btime, sizeof(info->btime));
245ce991cca55e Jeff Layton      2019-05-29  161  
245ce991cca55e Jeff Layton      2019-05-29  162  		/* change attribute */
a35ead314e0b92 Jeff Layton      2019-06-06  163  		ceph_decode_64_safe(p, end, info->change_attr, bad);
b37fe1f923fb4b Yan, Zheng       2019-01-09  164  
08796873a5183b Yan, Zheng       2019-01-09  165  		/* dir pin */
08796873a5183b Yan, Zheng       2019-01-09  166  		if (struct_v >= 2) {
08796873a5183b Yan, Zheng       2019-01-09  167  			ceph_decode_32_safe(p, end, info->dir_pin, bad);
08796873a5183b Yan, Zheng       2019-01-09  168  		} else {
08796873a5183b Yan, Zheng       2019-01-09  169  			info->dir_pin = -ENODATA;
08796873a5183b Yan, Zheng       2019-01-09  170  		}
08796873a5183b Yan, Zheng       2019-01-09  171  
193e7b37628e97 David Disseldorp 2019-04-18  172  		/* snapshot birth time, remains zero for v<=2 */
193e7b37628e97 David Disseldorp 2019-04-18  173  		if (struct_v >= 3) {
193e7b37628e97 David Disseldorp 2019-04-18  174  			ceph_decode_need(p, end, sizeof(info->snap_btime), bad);
193e7b37628e97 David Disseldorp 2019-04-18  175  			ceph_decode_copy(p, &info->snap_btime,
193e7b37628e97 David Disseldorp 2019-04-18  176  					 sizeof(info->snap_btime));
193e7b37628e97 David Disseldorp 2019-04-18  177  		} else {
193e7b37628e97 David Disseldorp 2019-04-18  178  			memset(&info->snap_btime, 0, sizeof(info->snap_btime));
193e7b37628e97 David Disseldorp 2019-04-18  179  		}
193e7b37628e97 David Disseldorp 2019-04-18  180  
e7f72952508ac4 Yanhu Cao        2020-08-28  181  		/* snapshot count, remains zero for v<=3 */
e7f72952508ac4 Yanhu Cao        2020-08-28  182  		if (struct_v >= 4) {
e7f72952508ac4 Yanhu Cao        2020-08-28  183  			ceph_decode_64_safe(p, end, info->rsnaps, bad);
e7f72952508ac4 Yanhu Cao        2020-08-28  184  		} else {
e7f72952508ac4 Yanhu Cao        2020-08-28  185  			info->rsnaps = 0;
e7f72952508ac4 Yanhu Cao        2020-08-28  186  		}
e7f72952508ac4 Yanhu Cao        2020-08-28  187  
d77b55b952a06f Jeff Layton      2020-07-27  188  		if (struct_v >= 5) {
d77b55b952a06f Jeff Layton      2020-07-27  189  			u32 alen;
d77b55b952a06f Jeff Layton      2020-07-27  190  
d77b55b952a06f Jeff Layton      2020-07-27  191  			ceph_decode_32_safe(p, end, alen, bad);
d77b55b952a06f Jeff Layton      2020-07-27  192  
d77b55b952a06f Jeff Layton      2020-07-27  193  			while (alen--) {
d77b55b952a06f Jeff Layton      2020-07-27  194  				u32 len;
d77b55b952a06f Jeff Layton      2020-07-27  195  
d77b55b952a06f Jeff Layton      2020-07-27  196  				/* key */
d77b55b952a06f Jeff Layton      2020-07-27  197  				ceph_decode_32_safe(p, end, len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  198  				ceph_decode_skip_n(p, end, len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  199  				/* value */
d77b55b952a06f Jeff Layton      2020-07-27  200  				ceph_decode_32_safe(p, end, len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  201  				ceph_decode_skip_n(p, end, len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  202  			}
d77b55b952a06f Jeff Layton      2020-07-27  203  		}
d77b55b952a06f Jeff Layton      2020-07-27  204  
d77b55b952a06f Jeff Layton      2020-07-27  205  		/* fscrypt flag -- ignore */
d77b55b952a06f Jeff Layton      2020-07-27  206  		if (struct_v >= 6)
d77b55b952a06f Jeff Layton      2020-07-27  207  			ceph_decode_skip_8(p, end, bad);
d77b55b952a06f Jeff Layton      2020-07-27  208  
d77b55b952a06f Jeff Layton      2020-07-27  209  		info->fscrypt_auth = NULL;
d77b55b952a06f Jeff Layton      2020-07-27  210  		info->fscrypt_auth_len = 0;
d77b55b952a06f Jeff Layton      2020-07-27  211  		info->fscrypt_file = NULL;
d77b55b952a06f Jeff Layton      2020-07-27  212  		info->fscrypt_file_len = 0;
d77b55b952a06f Jeff Layton      2020-07-27  213  		if (struct_v >= 7) {
d77b55b952a06f Jeff Layton      2020-07-27  214  			ceph_decode_32_safe(p, end, info->fscrypt_auth_len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  215  			if (info->fscrypt_auth_len) {
d77b55b952a06f Jeff Layton      2020-07-27  216  				info->fscrypt_auth = kmalloc(info->fscrypt_auth_len, GFP_KERNEL);
d77b55b952a06f Jeff Layton      2020-07-27  217  				if (!info->fscrypt_auth)
d77b55b952a06f Jeff Layton      2020-07-27 @218  					return -ENOMEM;

When I scroll down, it turns out that the error labels in this function
are just Pointless Do Nothing Gotos.  Smatch tries to ignore this, but
the bad: label sets the error code so Smatch marks it as a Do Something
label.

Ideally everything would be converted to direct returns...

d77b55b952a06f Jeff Layton      2020-07-27  219  				ceph_decode_copy_safe(p, end, info->fscrypt_auth,
d77b55b952a06f Jeff Layton      2020-07-27  220  						      info->fscrypt_auth_len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  221  			}
d77b55b952a06f Jeff Layton      2020-07-27  222  			ceph_decode_32_safe(p, end, info->fscrypt_file_len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  223  			if (info->fscrypt_file_len) {
d77b55b952a06f Jeff Layton      2020-07-27  224  				info->fscrypt_file = kmalloc(info->fscrypt_file_len, GFP_KERNEL);
d77b55b952a06f Jeff Layton      2020-07-27  225  				if (!info->fscrypt_file)
d77b55b952a06f Jeff Layton      2020-07-27  226  					return -ENOMEM;
d77b55b952a06f Jeff Layton      2020-07-27  227  				ceph_decode_copy_safe(p, end, info->fscrypt_file,
d77b55b952a06f Jeff Layton      2020-07-27  228  						      info->fscrypt_file_len, bad);
d77b55b952a06f Jeff Layton      2020-07-27  229  			}
d77b55b952a06f Jeff Layton      2020-07-27  230  		}
b37fe1f923fb4b Yan, Zheng       2019-01-09  231  		*p = end;
b37fe1f923fb4b Yan, Zheng       2019-01-09  232  	} else {
d77b55b952a06f Jeff Layton      2020-07-27  233  		/* legacy (unversioned) struct */
fb01d1f8b0343f Yan, Zheng       2014-11-14  234  		if (features & CEPH_FEATURE_MDS_INLINE_DATA) {
fb01d1f8b0343f Yan, Zheng       2014-11-14  235  			ceph_decode_64_safe(p, end, info->inline_version, bad);
fb01d1f8b0343f Yan, Zheng       2014-11-14  236  			ceph_decode_32_safe(p, end, info->inline_len, bad);
fb01d1f8b0343f Yan, Zheng       2014-11-14  237  			ceph_decode_need(p, end, info->inline_len, bad);
fb01d1f8b0343f Yan, Zheng       2014-11-14  238  			info->inline_data = *p;
fb01d1f8b0343f Yan, Zheng       2014-11-14  239  			*p += info->inline_len;
fb01d1f8b0343f Yan, Zheng       2014-11-14  240  		} else
fb01d1f8b0343f Yan, Zheng       2014-11-14  241  			info->inline_version = CEPH_INLINE_NONE;
fb01d1f8b0343f Yan, Zheng       2014-11-14  242  
fb18a57568c2b8 Luis Henriques   2018-01-05  243  		if (features & CEPH_FEATURE_MDS_QUOTA) {
b37fe1f923fb4b Yan, Zheng       2019-01-09  244  			err = parse_reply_info_quota(p, end, info);
b37fe1f923fb4b Yan, Zheng       2019-01-09  245  			if (err < 0)
b37fe1f923fb4b Yan, Zheng       2019-01-09  246  				goto out_bad;
fb18a57568c2b8 Luis Henriques   2018-01-05  247  		} else {
fb18a57568c2b8 Luis Henriques   2018-01-05  248  			info->max_bytes = 0;
fb18a57568c2b8 Luis Henriques   2018-01-05  249  			info->max_files = 0;
fb18a57568c2b8 Luis Henriques   2018-01-05  250  		}
fb18a57568c2b8 Luis Henriques   2018-01-05  251  
779fe0fb8e1883 Yan, Zheng       2016-03-07  252  		info->pool_ns_len = 0;
779fe0fb8e1883 Yan, Zheng       2016-03-07  253  		info->pool_ns_data = NULL;
5ea5c5e0a7f70b Yan, Zheng       2016-02-14  254  		if (features & CEPH_FEATURE_FS_FILE_LAYOUT_V2) {
5ea5c5e0a7f70b Yan, Zheng       2016-02-14  255  			ceph_decode_32_safe(p, end, info->pool_ns_len, bad);
779fe0fb8e1883 Yan, Zheng       2016-03-07  256  			if (info->pool_ns_len > 0) {
5ea5c5e0a7f70b Yan, Zheng       2016-02-14  257  				ceph_decode_need(p, end, info->pool_ns_len, bad);
779fe0fb8e1883 Yan, Zheng       2016-03-07  258  				info->pool_ns_data = *p;
5ea5c5e0a7f70b Yan, Zheng       2016-02-14  259  				*p += info->pool_ns_len;
779fe0fb8e1883 Yan, Zheng       2016-03-07  260  			}
5ea5c5e0a7f70b Yan, Zheng       2016-02-14  261  		}
08796873a5183b Yan, Zheng       2019-01-09  262  
245ce991cca55e Jeff Layton      2019-05-29  263  		if (features & CEPH_FEATURE_FS_BTIME) {
245ce991cca55e Jeff Layton      2019-05-29  264  			ceph_decode_need(p, end, sizeof(info->btime), bad);
245ce991cca55e Jeff Layton      2019-05-29  265  			ceph_decode_copy(p, &info->btime, sizeof(info->btime));
a35ead314e0b92 Jeff Layton      2019-06-06  266  			ceph_decode_64_safe(p, end, info->change_attr, bad);
245ce991cca55e Jeff Layton      2019-05-29  267  		}
245ce991cca55e Jeff Layton      2019-05-29  268  
08796873a5183b Yan, Zheng       2019-01-09  269  		info->dir_pin = -ENODATA;
e7f72952508ac4 Yanhu Cao        2020-08-28  270  		/* info->snap_btime and info->rsnaps remain zero */
b37fe1f923fb4b Yan, Zheng       2019-01-09  271  	}
2f2dc053404feb Sage Weil        2009-10-06  272  	return 0;
2f2dc053404feb Sage Weil        2009-10-06  273  bad:
b37fe1f923fb4b Yan, Zheng       2019-01-09  274  	err = -EIO;
b37fe1f923fb4b Yan, Zheng       2019-01-09  275  out_bad:
2f2dc053404feb Sage Weil        2009-10-06  276  	return err;
2f2dc053404feb Sage Weil        2009-10-06  277  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

