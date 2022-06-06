Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB61253E68A
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiFFK0v (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 06:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiFFK0t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 06:26:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B80933E2D
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 03:26:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBF560E09
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 10:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD78C385A9;
        Mon,  6 Jun 2022 10:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654511207;
        bh=GffHJitk7hTbyWLgkIAXyM+oR5K8a9yLZcYsYgMZP3Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IHx/iIrZW3ITn6NLuvO6ghnj0swO4aJ32blSsatU9TNYNeHyV7eZAjgNEnNe2zMGi
         4yZCAgv/ex6v8g1N1unqK8LJvtThKF5aB9ACIK2BY9KiyTyEzkEavKZCp24kDoHnjB
         JluWiRF53Vk40718CuoUbOgIuxgkO1EaHNnUS9sVo4WdY/hIXBqiAjsc0gSxy5ueiy
         EJUisb/Cnc+tZY/SBBceeq+8WYJD0lkruEBkTyQRtk6NoNdfLaNVLXS9gRHTrQ01b1
         wbGkjM4guKx7r0P/5YqeipoLrDiy2zvlZR+M7AoRZ9AomoQmJVenUycxDRswFXqmpi
         g4iOQBW+tmqCA==
Message-ID: <a461492826894c4cba6ba793469c8ba1ce8b140c.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        ukernel <ukernel@gmail.com>
Date:   Mon, 06 Jun 2022 06:26:45 -0400
In-Reply-To: <4aa4ce81-4a49-7e0a-ede7-204149d1c9ca@redhat.com>
References: <20220603203957.55337-1-jlayton@kernel.org>
         <4aa4ce81-4a49-7e0a-ede7-204149d1c9ca@redhat.com>
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

On Mon, 2022-06-06 at 13:17 +0800, Xiubo Li wrote:
> On 6/4/22 4:39 AM, Jeff Layton wrote:
> > When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
> > held and the function is expected to release it before returning. It
> > currently fails to do that in all cases which could lead to a deadlock.
> >=20
> > URL: https://tracker.ceph.com/issues/55857
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/caps.c | 27 +++++++++++++--------------
> >   1 file changed, 13 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 258093e9074d..0a48bf829671 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inod=
e,
> >   			fill_inline =3D true;
> >   	}
> >  =20
> > -	if (ci->i_auth_cap =3D=3D cap &&
> > -	    le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_IMPORT) {
> > -		if (newcaps & ~extra_info->issued)
> > -			wake =3D true;
> > +	if (le32_to_cpu(grant->op) =3D=3D CEPH_CAP_OP_IMPORT) {
> > +		if (ci->i_auth_cap =3D=3D cap) {
> > +			if (newcaps & ~extra_info->issued)
> > +				wake =3D true;
> > +
> > +			if (ci->i_requested_max_size > max_size ||
> > +			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> > +				/* re-request max_size if necessary */
> > +				ci->i_requested_max_size =3D 0;
> > +				wake =3D true;
> > +			}
> >  =20
> > -		if (ci->i_requested_max_size > max_size ||
> > -		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> > -			/* re-request max_size if necessary */
> > -			ci->i_requested_max_size =3D 0;
> > -			wake =3D true;
> > +			ceph_kick_flushing_inode_caps(session, ci);
> >   		}
> > -
> > -		ceph_kick_flushing_inode_caps(session, ci);
> > -		spin_unlock(&ci->i_ceph_lock);
> >   		up_read(&session->s_mdsc->snap_rwsem);
> > -	} else {
> > -		spin_unlock(&ci->i_ceph_lock);
> >   	}
> > +	spin_unlock(&ci->i_ceph_lock);
> >  =20
> >   	if (fill_inline)
> >   		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
>=20
> I am not sure what the following code in Line#4139 wants to do, more=20
> detail please see [1].
>=20
> 4131=A0=A0=A0=A0=A0=A0=A0=A0 if (msg_version >=3D 3) {
> 4132=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (op =3D=3D CEPH_C=
AP_OP_IMPORT) {
> 4133=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 if (p + sizeof(*peer) > end)
> 4134=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto bad;
> 4135=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 peer =3D p;
> 4136=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 p +=3D sizeof(*peer);
> 4137=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 } else if (op =3D=3D=
 CEPH_CAP_OP_EXPORT) {
> 4138=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 /* recorded in unused fields */
> 4139=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 peer =3D (void *)&h->size;
> 4140 }
> 4141=A0=A0=A0=A0=A0=A0=A0=A0 }
>=20
> For the export case the members in the 'peer' are always assigned to=20
> 'random' values. And seems could cause this issue.
>=20
> [1] https://github.com/ceph/ceph-client/blob/for-linus/fs/ceph/caps.c#L41=
34
>=20
> I am still reading the code. Any idea ?
>=20
>=20

I'm not sure that this is the case. It looks like most of the places in
the mds code that make a CEPH_CAP_OP_EXPORT message call set_cap_peer
just afterward. Why do you think this is given random values?

--=20
Jeff Layton <jlayton@kernel.org>
