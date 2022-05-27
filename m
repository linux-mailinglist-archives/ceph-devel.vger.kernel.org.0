Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA83536925
	for <lists+ceph-devel@lfdr.de>; Sat, 28 May 2022 01:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352865AbiE0XSs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 May 2022 19:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347750AbiE0XSs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 May 2022 19:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEF8F344FF
        for <ceph-devel@vger.kernel.org>; Fri, 27 May 2022 16:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653693522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lzjcwLEqQ1h8cY4/7Oyis5K+Ro4ryBP7YXyVB/dn90g=;
        b=e7RG5tXe/h5Do1Um+C+as+V1EUoaetqE13iV+7rfBfdZQcoXiX4HIh7NU2eFVj0F6Bryyj
        kTR4IL84X9+wzG1fC7QbUVBe3jIzzYUR0uFwUBU+w1HzUm3jcK8kPTs7czI/hO75FLGi6G
        9efUmqiiOklF2/kHIcWTOdys4LUMRzQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-SM9jVFfOMuW3p3rD3pa2gg-1; Fri, 27 May 2022 19:18:41 -0400
X-MC-Unique: SM9jVFfOMuW3p3rD3pa2gg-1
Received: by mail-pf1-f199.google.com with SMTP id z24-20020a056a001d9800b0051868682940so3035075pfw.1
        for <ceph-devel@vger.kernel.org>; Fri, 27 May 2022 16:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lzjcwLEqQ1h8cY4/7Oyis5K+Ro4ryBP7YXyVB/dn90g=;
        b=YXJecZx5Z/5CfEsC6Bde7AOt8Q1AhQObTjQNgGycf9xIxjVfYzUkcUp34lS9+bpccA
         LCVnhUxpwps0FUizNuPZZrSddR1rs1PBmz0/dL33bqhC+3274BJuW8DG6ixIY797La5g
         RlmrFs0YGnuV7xGPP63aA7x5K0+zNLrYIe2mr+VBHFpp1vqCeH5HSFVDLk0UOrWW0LIj
         n0FY/702r/rDB/BG2he1zEt2NIfh7c6bAGyZo3xPHmi6VGCKOwsR4eLk9NJ9Qlq0v8lA
         qS9QfGgpeRCRC+dxcJt5W2HOc65y3H5Xc15r83e3VhW0vmLD9b3mYD9X5g8lMKYBkALm
         NG3g==
X-Gm-Message-State: AOAM53208KeFg9QbpNzuG/Snc0ZyUR2yekiL3GbCOx66oQ8pyNLWAhNE
        QolFFusksZ7/Sp70Xs7ajNk93OV8cEBfYVXwPjZE+MC1WBaT+3EkW0E98Xm/vUZPLZADNz8736i
        h/TItddMTQercMZFlbnEhbaWS+TPWabTznwFlxM296lGyUa7iA7IEXZYrrUqnCiukd6HhkZk=
X-Received: by 2002:a62:8206:0:b0:518:3c6a:21ba with SMTP id w6-20020a628206000000b005183c6a21bamr44970171pfd.63.1653693520177;
        Fri, 27 May 2022 16:18:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNiV/6ANWgR5pw2I0aEPdh7/7coj3yqBKEUAw6IpQJ6I9bJjR7R96jnLTyh+IuAPjfjUxqbQ==
X-Received: by 2002:a62:8206:0:b0:518:3c6a:21ba with SMTP id w6-20020a628206000000b005183c6a21bamr44970146pfd.63.1653693519751;
        Fri, 27 May 2022 16:18:39 -0700 (PDT)
Received: from [10.72.12.81] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v1-20020aa78081000000b0050dc7628178sm4021490pff.82.2022.05.27.16.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 16:18:39 -0700 (PDT)
Subject: Re: staging in the fscrypt patches
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Luis Henriques <lhenriques@suse.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
References: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <29cbaebe-1bbb-b9d5-44c2-b29da32bb9fc@redhat.com>
Date:   Sat, 28 May 2022 07:18:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/28/22 12:34 AM, Jeff Layton wrote:
> Once the Ceph PR for this merge window has gone through, I'd like to
> start merging in some of the preliminary fscrypt patches. In particular,
> I'd like to merge these two patches into ceph-client/master so that they
> go to linux-next:
>
> be2bc0698248 fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
> 7feda88977b8 fscrypt: add fscrypt_context_for_new_inode
>
> I'd like to see these in ceph-client/testing, so that they start getting
> some exposure in teuthology:
>
> 477944c2ed29 libceph: add spinlock around osd->o_requests
> 355d9572686c libceph: define struct ceph_sparse_extent and add some helpers
> 229a3e2cf1c7 libceph: add sparse read support to msgr2 crc state machine
> a0a9795c2a2c libceph: add sparse read support to OSD client
> 6a16e0951aaf libceph: support sparse reads on msgr2 secure codepath
> 538b618f8726 libceph: add sparse read support to msgr1
> 7ef4c2c39f05 ceph: add new mount option to enable sparse reads
> b609087729f4 ceph: preallocate inode for ops that may create one
> e66323d65639 ceph: make ceph_msdc_build_path use ref-walk
>
> ...they don't add any new functionality (other than the sparse read
> stuff), but they do change "normal" operation in some ways that we'll
> need later, so I'd like to see them start being regularly tested.
>
> If that goes OK, then I'll plan to start merging another tranche a
> couple of weeks after that.
>
> Does that sound OK?

Sounds good to me.

-- Xiubo


