Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD68355E1D2
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jun 2022 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238464AbiF0Lxj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jun 2022 07:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiF0Lwu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Jun 2022 07:52:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00206DF25
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 04:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF69FB80D37
        for <ceph-devel@vger.kernel.org>; Mon, 27 Jun 2022 11:46:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF781C341C7;
        Mon, 27 Jun 2022 11:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656330391;
        bh=T7PEXQg7nvzt6TNqyCBE0VnAAKl2B3HLOYL89HltXr8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YFRBL3VBIRmjaWidVyChiLkWpkeVr93SbI2jrJbAT9xwKrfC55JJbY7/rtgkpFNJm
         JmjqwytYgFIkRQqSB90k3Hcy1oufSVtpRKeTOt4+SF+bJdzpheOjnRcWzF0NLHKC8d
         zJyQO5k0KNMIhS7bhYmHYHMQme6VxLv+nCfkeHnV735yk2XUS6Z0wo1nkoD8FeBEu2
         DWsDb0xjIU+PtZZiW9Oji5n3xgPjJ7PhO0762zzL/wQZ6yI+vBryeoHS+cB/2VaY0c
         kzRjycVUeOAg15DdHhAU+l2eosU1dNR7jQOHomnFnPFd1exAtg9dEcH2WJY1jDeGOx
         i+2Bnre/DkAoA==
Message-ID: <bed4d3dab38ac23fd22ff9a41c5c8d667c0fbc72.camel@kernel.org>
Subject: Re: [PATCH 0/2] ceph: add new iov_iter type and use it for reads
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date:   Mon, 27 Jun 2022 07:46:29 -0400
In-Reply-To: <20220609193423.167942-1-jlayton@kernel.org>
References: <20220609193423.167942-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-06-09 at 15:34 -0400, Jeff Layton wrote:
> This patchset was inspired by some earlier work that David Howells did
> to add a similar type.
>=20
> Currently, we take an iov_iter from the netfs layer, turn that into an
> array of pages, and then pass that to the messenger which eventually
> turns that back into an iov_iter before handing it back to the socket.
>=20
> This patchset adds a new ceph_msg_data_type that uses an iov_iter
> directly instead of requiring an array of pages or bvecs. This allows
> us to avoid an extra allocation in the buffered read path, and should
> make it easier to plumb in write helpers later.
>=20
> For now, this is still just a slow, stupid implementation that hands
> the socket layer a page at a time like the existing messenger does. It
> doesn't yet attempt to pass through the iov_iter directly.
>=20
> I have some patches that pass the cursor's iov_iter directly to the
> socket in the receive path, but it requires some infrastructure that's
> not in mainline yet (iov_iter_scan(), for instance). It should be
> possible to something similar in the send path as well.
>=20
> Jeff Layton (2):
>   libceph: add new iov_iter-based ceph_msg_data_type and
>     ceph_osd_data_type
>   ceph: use osd_req_op_extent_osd_iter for netfs reads
>=20
>  fs/ceph/addr.c                  | 18 +---------
>  include/linux/ceph/messenger.h  |  5 +++
>  include/linux/ceph/osd_client.h |  4 +++
>  net/ceph/messenger.c            | 64 +++++++++++++++++++++++++++++++++
>  net/ceph/osd_client.c           | 27 ++++++++++++++
>  5 files changed, 101 insertions(+), 17 deletions(-)
>=20

I've had these sitting in testing branch for a bit and they seem to work
just fine. Unfortunately though, Al mentioned on IRC that he was
planning to change iov_iter_get_pages to auto-advance the iterator,
which will require a redesign of the first patch. I'm going to drop this
series from the testing branch for now.

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>
