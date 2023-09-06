Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5251F793CAF
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Sep 2023 14:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235536AbjIFMeq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 08:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjIFMep (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 08:34:45 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8694184
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 05:34:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-401b3ea0656so33447505e9.0
        for <ceph-devel@vger.kernel.org>; Wed, 06 Sep 2023 05:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694003680; x=1694608480; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0eYV8UHYKgmelHH99d95mQ3MRzVv3IZBEV85AvQF8E4=;
        b=dvtD/1kTROkUJfwUO4UfP2Y1AS5L2z1YXxnV4g33l2ENKIKc074j9NN/WcnHmzzhdB
         Xqx/Y6nVhgUqpuBeegHq1rf3PEoVg0A44RId7rIlsK5hLtwsz7A4pq9MTuPjnaopNWDs
         E7QB0myb59YfKHjhqDqEYWD5r00j2zYWdhNogjxbiw0KeBcs3CtXmuPLV807DUaLgcC0
         RVaqxbLWg8Q1SbCW1mtvk6MSUumi32GcjsXgdGjE0oyqh+zlUw6R9T2Q116n3lHsOg2b
         v2No1oAx+QXcSn/Hor7qC1acPm771kgQyr75syqnp80l5cDthybqyHO7ODGpI4sIe6Ef
         Bj3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694003680; x=1694608480;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0eYV8UHYKgmelHH99d95mQ3MRzVv3IZBEV85AvQF8E4=;
        b=fskXMbv8qi3VhSH1mQfoVYheizTKc/OuLxe/JRjYGOg7Zt5TGo2Mv2MliMym4zkG/9
         iXLJ8RdIioWZXCDrgfUIp8/rFf0Q956kYNt1KbziWiMfCktemnZf4HGR5S98yFtFOGDM
         0ZqFkI/wdw7LRzXNNYI0YR7E4k8au1pJi+VaWisILxq3WGdDVmxUfH+y5iLLpS/eqr20
         ifrNGFvhCp3jsK4mnCjQ1GQzq4BO/VF6yjnqi5Usdpj7iFKTyDWSM7Uk5bdQX1xf2pi9
         mOJUVrKFdoyyu7F3lm7ElUyDdkZgy8GembghP8yl73IkDA8xW8XJvTRcoaYD/7LCVgb3
         I6RQ==
X-Gm-Message-State: AOJu0Yxh6MJr3yX0bLUsQ2SfNaEBjjrpdpOCofmBAWEvXQY1w3nl2DXh
        D+iH9aDuDCLgTkJ8zkXumcFSjIYsaZgr2Tyvnk8=
X-Google-Smtp-Source: AGHT+IEV5dod/AxqGZxssBVBR13iYNqj3yx86xIr2wBtxjB+FUnJg070Hs2hxKSPWgWcdc9VfXgIQg==
X-Received: by 2002:a05:6000:923:b0:317:f7b0:85f with SMTP id cx3-20020a056000092300b00317f7b0085fmr2142054wrb.33.1694003680412;
        Wed, 06 Sep 2023 05:34:40 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w2-20020adff9c2000000b00317ddccb0d1sm20272524wrr.24.2023.09.06.05.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 05:34:39 -0700 (PDT)
Date:   Wed, 6 Sep 2023 15:34:36 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     lhenriques@suse.de
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: [bug report] ceph: add support for encrypted snapshot names
Message-ID: <940a3e16-50d2-407b-bf45-b794bad64c3f@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello Luís Henriques,

The patch dd66df0053ef: "ceph: add support for encrypted snapshot
names" from Aug 25, 2022 (linux-next), leads to the following Smatch
static checker warning:

	fs/ceph/crypto.c:252 parse_longname()
	warn: 'dir' is an error pointer or valid

fs/ceph/crypto.c
    211 static struct inode *parse_longname(const struct inode *parent,
    212                                     const char *name, int *name_len)
    213 {
    214         struct inode *dir = NULL;
    215         struct ceph_vino vino = { .snap = CEPH_NOSNAP };
    216         char *inode_number;
    217         char *name_end;
    218         int orig_len = *name_len;
    219         int ret = -EIO;
    220 
    221         /* Skip initial '_' */
    222         name++;
    223         name_end = strrchr(name, '_');
    224         if (!name_end) {
    225                 dout("Failed to parse long snapshot name: %s\n", name);
    226                 return ERR_PTR(-EIO);
    227         }
    228         *name_len = (name_end - name);
    229         if (*name_len <= 0) {
    230                 pr_err("Failed to parse long snapshot name\n");
    231                 return ERR_PTR(-EIO);
    232         }
    233 
    234         /* Get the inode number */
    235         inode_number = kmemdup_nul(name_end + 1,
    236                                    orig_len - *name_len - 2,
    237                                    GFP_KERNEL);
    238         if (!inode_number)
    239                 return ERR_PTR(-ENOMEM);
    240         ret = kstrtou64(inode_number, 10, &vino.ino);
    241         if (ret) {
    242                 dout("Failed to parse inode number: %s\n", name);
    243                 dir = ERR_PTR(ret);
    244                 goto out;
    245         }
    246 
    247         /* And finally the inode */
    248         dir = ceph_find_inode(parent->i_sb, vino);
    249         if (!dir) {
    250                 /* This can happen if we're not mounting cephfs on the root */
    251                 dir = ceph_get_inode(parent->i_sb, vino, NULL);
--> 252                 if (!dir)
    253                         dir = ERR_PTR(-ENOENT);

This never returns NULL.  If it were tempted to return NULL then it
returns -ENOMEM instead.

    254         }
    255         if (IS_ERR(dir))
    256                 dout("Can't find inode %s (%s)\n", inode_number, name);
    257 
    258 out:
    259         kfree(inode_number);
    260         return dir;
    261 }

regards,
dan carpenter
