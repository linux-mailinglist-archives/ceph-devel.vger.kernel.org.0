Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF58C52BE7E
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbiEROwp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239031AbiEROwo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C451A0ADB
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:52:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 436686196F
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 14:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB9DC385AA;
        Wed, 18 May 2022 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652885562;
        bh=ixkS3eCPAYFb1pk4NQtqP4jxpjJrXd9I0cvRkKDq+lE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mqeu+TTWfSzim7fqqJzGikvjbZohEHeuR4P8xv9VLoyrH8G5ZvTqLbv1ldiTqxQLd
         AtJsLcEM8Mphty/Qmr6NZnPj6e1CDiw2AbP2JvSAtCWguK0I8zCMP5AAVy0hYgN7Pi
         8DoJvImY92pkPQsPRG2U/xtr9Q4GW9I1DnyHyuFOlU/QfNtUhzuZPAtCFBQlLYj8KU
         v1hGj4Viy8lGvJm9df8dVXnEcKCVTXnoaPhkDFfRviZBTGK3YPab5ahodbxgCKlo5p
         Z4RHtb2ZtlgSUr2pf3MNR4LURlpnUPFKL1x+MhplnNe4w/hIKe7efElYMkEya3xh4z
         oLBY2Se0eJ5GA==
Message-ID: <c193b36ea20bf31937898d84d2db03aca5c7a7a9.camel@kernel.org>
Subject: Re: [PATCH] libceph: fix misleading ceph_osdc_cancel_request()
 comment
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Date:   Wed, 18 May 2022 10:52:40 -0400
In-Reply-To: <20220517095534.15288-1-idryomov@gmail.com>
References: <20220517095534.15288-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-05-17 at 11:55 +0200, Ilya Dryomov wrote:
> cancel_request() never guaranteed that after its return the OSD
> client would be completely done with the OSD request.  The callback
> (if specified) can still be invoked and a ref can still be held.
>=20
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/osd_client.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 4b88f2a4a6e2..9d82bb42e958 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -4591,8 +4591,13 @@ int ceph_osdc_start_request(struct ceph_osd_client=
 *osdc,
>  EXPORT_SYMBOL(ceph_osdc_start_request);
> =20
>  /*
> - * Unregister a registered request.  The request is not completed:
> - * ->r_result isn't set and __complete_request() isn't called.
> + * Unregister request.  If @req was registered, it isn't completed:
> + * r_result isn't set and __complete_request() isn't invoked.
> + *
> + * If @req wasn't registered, this call may have raced with
> + * handle_reply(), in which case r_result would already be set and
> + * __complete_request() would be getting invoked, possibly even
> + * concurrently with this call.
>   */
>  void ceph_osdc_cancel_request(struct ceph_osd_request *req)
>  {

Reviewed-by: Jeff Layton <jlayton@kernel.org>
