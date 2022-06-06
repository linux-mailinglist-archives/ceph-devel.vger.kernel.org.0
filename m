Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A5553E8DE
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiFFKZ1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 06:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbiFFKXU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 06:23:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2A2634D
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 03:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3759160DDF
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 10:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A33FC385A9;
        Mon,  6 Jun 2022 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654510998;
        bh=v8qWBGgp8/sm5SWXjC2sHfGa1pkPAit2PC/PRiRDZzc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Kb0CTH5RTkxlAXd43HWmLy6LBmaPwb1beLQmyzEQTs5ku22zFZTXqyGnpSPCEanQC
         u87kao57KDFA5e9134HrylFtgqte8/b7XvF3pxDkoGeSk+XzblA3un/FdbGxoNP7PZ
         fBFSbufyT8kpJwXYn51NknaOj2m6NxbeujpquKHZoa/a6/3R7DL9WwKONKinfgqwdT
         tNuyvpKKuwnl8AR/apm1VC31zUiGWuZaS1vjWxZrP+Ti4ASiX7cb7s2ogzmKaonDaf
         L3rd2rZavkuAOzXOtGKn7/uF1XLvJxFUXZH3tdm3ouBTqWznh9Z3Dg6cw8HI1jnqxj
         KXOidv/fIwnHg==
Message-ID: <a60d5c710b68a7fff35113df0fac754d199db075.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix incorrectly assigning random values to peer's
 members
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        ukernel <ukernel@gmail.com>
Date:   Mon, 06 Jun 2022 06:23:16 -0400
In-Reply-To: <20220606072835.302935-1-xiubli@redhat.com>
References: <20220606072835.302935-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-06-06 at 15:28 +0800, Xiubo Li wrote:
> For export the peer is empty in ceph.
>=20
> URL: https://tracker.ceph.com/issues/55857
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0a48bf829671..8efa46ff4282 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4127,16 +4127,11 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
>  		p +=3D flock_len;
>  	}
> =20
> -	if (msg_version >=3D 3) {
> -		if (op =3D=3D CEPH_CAP_OP_IMPORT) {
> -			if (p + sizeof(*peer) > end)
> -				goto bad;
> -			peer =3D p;
> -			p +=3D sizeof(*peer);
> -		} else if (op =3D=3D CEPH_CAP_OP_EXPORT) {
> -			/* recorded in unused fields */
> -			peer =3D (void *)&h->size;
> -		}
> +	if (msg_version >=3D 3 && op =3D=3D CEPH_CAP_OP_IMPORT) {
> +		if (p + sizeof(*peer) > end)
> +			goto bad;
> +		peer =3D p;
> +		p +=3D sizeof(*peer);
>  	}
> =20
>  	if (msg_version >=3D 4) {

This was added in commit 11df2dfb61 (ceph: add imported caps when
handling cap export message). If peer should always be NULL on an
export, I wonder what he was thinking by adding this in the first place?
Zheng, could you take a look here?

If this does turn out to be correct, then I think there is some further
cleanup you can do here, as you should be able to drop the peer argument
from handle_cap_export. That should also collapse some of the code down
in that function as well since lot of the target fields end up being 0s.

--=20
Jeff Layton <jlayton@kernel.org>
