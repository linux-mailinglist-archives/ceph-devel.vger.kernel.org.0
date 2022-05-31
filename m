Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8014353934A
	for <lists+ceph-devel@lfdr.de>; Tue, 31 May 2022 16:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345304AbiEaOrY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 May 2022 10:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345303AbiEaOrX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 31 May 2022 10:47:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F2037BEC
        for <ceph-devel@vger.kernel.org>; Tue, 31 May 2022 07:47:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EFB0612B5
        for <ceph-devel@vger.kernel.org>; Tue, 31 May 2022 14:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B38C34114;
        Tue, 31 May 2022 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654008442;
        bh=uI1kjQ/viCnRm333VMpaOzgmjO2cRAG6f7Vi5rMNK/g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MB2G7BQVSPdv5y/ICd2EpPvfBTpWsYtE1U9KPHOTgce9QGVcHnLSLhvo73Gdl4Pl0
         kV5PW3eeg5AfPPtQKXqf/frBRSlftU6Vn7IrXC4+go+uo4NIyBs3N93nZNbDntjwH9
         JLO1jJW1iawFui37R2nmGzf1nhU+r0NiH83Neidv1QyfVKWHKrzUO8sT9+N0hPcHLe
         pmIxf3XwIEgESrG/IafGeDcyiytp4EQeErBOqEnutzxS5es2/UTrtilG4j+oBpt4YH
         KiTgJhC6USkk5ZwjIoB+LoTlzMt0wdH0Nwg9JZ70h+c9V7E1110eoX6PpdKtzhRkgg
         dS0fIArFxDMjQ==
Message-ID: <22048087125ec34b3cb08a9bbb68c00d17d5eeba.camel@kernel.org>
Subject: Re: staging in the fscrypt patches
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Luis Henriques <lhenriques@suse.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 31 May 2022 10:47:20 -0400
In-Reply-To: <29cbaebe-1bbb-b9d5-44c2-b29da32bb9fc@redhat.com>
References: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
         <29cbaebe-1bbb-b9d5-44c2-b29da32bb9fc@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2022-05-28 at 07:18 +0800, Xiubo Li wrote:
> On 5/28/22 12:34 AM, Jeff Layton wrote:
> > Once the Ceph PR for this merge window has gone through, I'd like to
> > start merging in some of the preliminary fscrypt patches. In particular=
,
> > I'd like to merge these two patches into ceph-client/master so that the=
y
> > go to linux-next:
> >=20
> > be2bc0698248 fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_en=
crypted_size
> > 7feda88977b8 fscrypt: add fscrypt_context_for_new_inode
> >=20
> > I'd like to see these in ceph-client/testing, so that they start gettin=
g
> > some exposure in teuthology:
> >=20
> > 477944c2ed29 libceph: add spinlock around osd->o_requests
> > 355d9572686c libceph: define struct ceph_sparse_extent and add some hel=
pers
> > 229a3e2cf1c7 libceph: add sparse read support to msgr2 crc state machin=
e
> > a0a9795c2a2c libceph: add sparse read support to OSD client
> > 6a16e0951aaf libceph: support sparse reads on msgr2 secure codepath
> > 538b618f8726 libceph: add sparse read support to msgr1
> > 7ef4c2c39f05 ceph: add new mount option to enable sparse reads
> > b609087729f4 ceph: preallocate inode for ops that may create one
> > e66323d65639 ceph: make ceph_msdc_build_path use ref-walk
> >=20
> > ...they don't add any new functionality (other than the sparse read
> > stuff), but they do change "normal" operation in some ways that we'll
> > need later, so I'd like to see them start being regularly tested.
> >=20
> > If that goes OK, then I'll plan to start merging another tranche a
> > couple of weeks after that.
> >=20
> > Does that sound OK?
>=20
> Sounds good to me.
>=20
> -- Xiubo
>=20
>=20

Done. I've gone ahead and merged these patches into the two branches.
Please let me know if you encounter any issues from them!

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>
