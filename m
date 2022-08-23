Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8814759E731
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Aug 2022 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiHWQ1Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Aug 2022 12:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243927AbiHWQ05 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Aug 2022 12:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC56119119
        for <ceph-devel@vger.kernel.org>; Tue, 23 Aug 2022 05:52:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFDC6614A2
        for <ceph-devel@vger.kernel.org>; Tue, 23 Aug 2022 12:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1080C433D6;
        Tue, 23 Aug 2022 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661259124;
        bh=ek1SyWgxZVYKzn4Fz4pwJX5Ar7npKcb67DswwOE53mg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a7GBBzpx95fE1SRNEd4HVTD3DL8xe1azJUjfNYaH9a5JjFHOgA7AYb2haMzYuaEVU
         RO95x1WLIjFGZSH7xd63yxj49fSmuftBT1rq/C7Zd4tik8fsQxUiGmV81Dfj8ET4Vg
         FkdORnsxBaB6BVY4LEk+7wkIo0qwpBDAxDlDq87E78EuT2sA5DE8xQx3J/CxFctoPD
         CUJuThgiB+Bi3lttB88l0EtCxxLQwH70n5dYa4IFse7n6yV00s1+DCgy0hADe+pIDH
         lbT+5BNu3ZKyxnTZ0yS1Oh6TFIRz6vwhKp+WLQwwJ8SAfaRneKsSJNhCYWFsiAN4KA
         UjMrtqPrQd+IQ==
Message-ID: <836cffdedf70e9abbb0464da86bc123b0a0d74e9.camel@kernel.org>
Subject: Re: New Defects reported by Coverity Scan for ceph
From:   Jeff Layton <jlayton@kernel.org>
To:     Brad Hubbard <bhubbard@redhat.com>
Cc:     dev <dev@ceph.io>, ceph-devel@vger.kernel.org
Date:   Tue, 23 Aug 2022 08:52:02 -0400
In-Reply-To: <CAF-wwdHAAZLw4UpuHX_ykTVddhR2eZW9h8AkVnEMc4Om8Tqx=A@mail.gmail.com>
References: <6300d1f84dd26_5a1d52acd77b1b998717a9@prd-scan-dashboard-0.mail>
         <004f3c3a275a007dfee7f92787a4541090b18221.camel@kernel.org>
         <CAF-wwdHAAZLw4UpuHX_ykTVddhR2eZW9h8AkVnEMc4Om8Tqx=A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-08-22 at 13:54 +1000, Brad Hubbard wrote:
> On Sat, Aug 20, 2022 at 11:19 PM Jeff Layton <jlayton@kernel.org> wrote:
> >=20
> > This mailing list is for the ceph kernel client, but the report below i=
s
> > for the userland ceph project. Can you change where these alerts get
> > mailed to dev@ceph.io?
>=20
> Sorry Jeff,
>=20
> I'm pretty sure I've changed this but let me know if you get anything els=
e.

No problem. I just want to make sure that the right eyeballs see these.

--=20
Jeff Layton <jlayton@kernel.org>
