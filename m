Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C432F53660D
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbiE0QhA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 May 2022 12:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349330AbiE0QfC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 May 2022 12:35:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D63B2AE
        for <ceph-devel@vger.kernel.org>; Fri, 27 May 2022 09:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABD4D61DE3
        for <ceph-devel@vger.kernel.org>; Fri, 27 May 2022 16:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42D0C34113;
        Fri, 27 May 2022 16:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653669301;
        bh=07y+KNYUxKiYBieQmKF5O7aQOMxYfJyxhCU7PuTklxc=;
        h=Subject:From:To:Cc:Date:From;
        b=I9q8tNsSVGSpiXuPOMycmhhUtSLWzjKbzF4EU1p/kN5GM4D1Vf4W0qZBOWECviirn
         ML6c/XFfuwSdBQW7K/5MrPPlMAzBkvM3EbHyoNzdnwA/tQM1aasf+z42hOBks0clAd
         aJfMyZVCkNoLxYrsXvKLIquBbgqjtlNjCQ1yEFKBI8mOQsFMI8nzKDGX05HVeTZapK
         u9uul1PnvNOz7ob5viyK7fQ1PT8pIy9EDb4Tjl10o92t5dFis1jyT/ZwbcXi0c7kfc
         M4BgBYrvOrItf4gOXb/WZ8B497fDwpruZTjisUTQM9HJ6esQKepgWSqoQheTFgjF8P
         KbQx02RErxsFw==
Message-ID: <7de95a15fb97d7e60af6cbd9bac2150a17b9ad4f.camel@kernel.org>
Subject: staging in the fscrypt patches
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Luis Henriques <lhenriques@suse.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Fri, 27 May 2022 12:34:59 -0400
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Once the Ceph PR for this merge window has gone through, I'd like to
start merging in some of the preliminary fscrypt patches. In particular,
I'd like to merge these two patches into ceph-client/master so that they
go to linux-next:

be2bc0698248 fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encryp=
ted_size
7feda88977b8 fscrypt: add fscrypt_context_for_new_inode

I'd like to see these in ceph-client/testing, so that they start getting
some exposure in teuthology:

477944c2ed29 libceph: add spinlock around osd->o_requests
355d9572686c libceph: define struct ceph_sparse_extent and add some helpers
229a3e2cf1c7 libceph: add sparse read support to msgr2 crc state machine
a0a9795c2a2c libceph: add sparse read support to OSD client
6a16e0951aaf libceph: support sparse reads on msgr2 secure codepath
538b618f8726 libceph: add sparse read support to msgr1
7ef4c2c39f05 ceph: add new mount option to enable sparse reads
b609087729f4 ceph: preallocate inode for ops that may create one
e66323d65639 ceph: make ceph_msdc_build_path use ref-walk

...they don't add any new functionality (other than the sparse read
stuff), but they do change "normal" operation in some ways that we'll
need later, so I'd like to see them start being regularly tested.

If that goes OK, then I'll plan to start merging another tranche a
couple of weeks after that.

Does that sound OK?
--=20
Jeff Layton <jlayton@kernel.org>
