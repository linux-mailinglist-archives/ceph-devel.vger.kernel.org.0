Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844507C52DF
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Oct 2023 14:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbjJKMHE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Oct 2023 08:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjJKMHD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Oct 2023 08:07:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C9993
        for <ceph-devel@vger.kernel.org>; Wed, 11 Oct 2023 05:07:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706D1C433C8;
        Wed, 11 Oct 2023 12:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697026021;
        bh=tFhppGBYTVfoR/zH2jQ+I6wGMyiIAXE50U79NiRo1VQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jLXiu0pou11TygVzRDl7l1fwebKf+vHNYXg87148WJCYZnR6hTAtWzlSmFpo6pE1k
         UbjulokydwTHv2jWkjlclUkhDjl7Wfg8UskAqwmXr/3KYSkyOAN0YZ9UEWyyFQTJDF
         cQ7cNeiI4+A20T+DJ8sz5rO3hxCMOBznBdCSu5RiB05EPmWl2mgQvvNUPx371k05Yq
         j53pWDqVbUrX/0kyFWwSbFGil/k7tacRKkwmjTkYZcMRjEKoxRGGhRxnlJ6FYLoB3j
         dYopGrNHlJW15BqtHe6l1YJ2PTzIjCv2cAr1bW+mgGrylTUJTul3dAeRdSSlJVMlrJ
         0k9a4rREVQhDg==
Message-ID: <87c8dc9d4734e6e2a0250531bc08140880b4523d.camel@kernel.org>
Subject: Re: [bug report] libceph: add new iov_iter-based ceph_msg_data_type
 and ceph_osd_data_type
From:   Jeff Layton <jlayton@kernel.org>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     ceph-devel@vger.kernel.org, dhowells@redhat.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Date:   Wed, 11 Oct 2023 08:06:59 -0400
In-Reply-To: <c5a75561-b6c7-4217-9e70-4b3212fd05f8@moroto.mountain>
References: <c5a75561-b6c7-4217-9e70-4b3212fd05f8@moroto.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.module_f38+17164+63eeee4a) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2023-10-11 at 12:50 +0300, Dan Carpenter wrote:
> Hello Jeff Layton,
>=20
> To be honest, I'm not sure why I am only seeing this now.  These
> warnings are hard to analyse because they involve such a long call tree.
> Anyway, hopefully it's not too complicated for you since you know the
> code.
>=20
> The patch dee0c5f83460: "libceph: add new iov_iter-based
> ceph_msg_data_type and ceph_osd_data_type" from Jul 1, 2022
> (linux-next), leads to the following Smatch static checker warning:
>=20
> 	lib/iov_iter.c:905 want_pages_array()
> 	warn: sleeping in atomic context
>=20
> lib/iov_iter.c
>     896 static int want_pages_array(struct page ***res, size_t size,
>     897                             size_t start, unsigned int maxpages)
>     898 {
>     899         unsigned int count =3D DIV_ROUND_UP(size + start, PAGE_SI=
ZE);
>     900=20
>     901         if (count > maxpages)
>     902                 count =3D maxpages;
>     903         WARN_ON(!count);        // caller should've prevented tha=
t
>     904         if (!*res) {
> --> 905                 *res =3D kvmalloc_array(count, sizeof(struct page=
 *), GFP_KERNEL);
>     906                 if (!*res)
>     907                         return 0;
>     908         }
>     909         return count;
>     910 }
>=20
>=20
> prep_next_sparse_read() <- disables preempt
> -> advance_cursor()
>    -> ceph_msg_data_next()
>       -> ceph_msg_data_iter_next()
>          -> iov_iter_get_pages2()
>             -> __iov_iter_get_pages_alloc()
>                -> want_pages_array()
>=20
> The prep_next_sparse_read() functions hold the spin_lock(&o->o_requests_l=
ock);
> lock so it can't sleep.  But iov_iter_get_pages2() seems like a sleeping
> operation.
>=20
>=20

I think this is a false alarm, but I'd appreciate a sanity check:

iov_iter_get_pages2 has this:

	BUG_ON(!pages);

...which should ensure that *res won't be NULL when want_pages_array is
called. That said, this seems like kind of a fragile thing to rely on.
Should we do something to make this a bit less subtle?
--=20
Jeff Layton <jlayton@kernel.org>
