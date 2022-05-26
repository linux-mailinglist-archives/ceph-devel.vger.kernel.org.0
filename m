Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7861653507B
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiEZOUX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 10:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240517AbiEZOUW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 10:20:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B07C5D84
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 07:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B36BB81F1A
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 14:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F60C385A9;
        Thu, 26 May 2022 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653574818;
        bh=1KyCSKahD9yhNbkFHuV0qYKD0CmguGjCz4dKTu5JRY4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KOPexdQhRf75W75AUyePT4TMt15/5cs/Ztcnj3sgw0QQ/3UYyVkQ9rRbusqe0lP9G
         bqrq55DcWlh3iYUWWBWz9DiSBgc88hGZVZJ/mJ6peETRiCI+XWXcUIkng2JYlGhScn
         OESyxvctTOIYWzYD9zvZWGBWA4ncQWl7o/yRzO6k/HbIffTxV8VDjGC17meSgM/uoj
         yf3CLDkW+WU+0Stv3HjZ08GVmAkp4xhMgcYk4mN2OI1pG8y951leHOhFRYyY4HhdcY
         GZr1rG8vm8wP/f8rHi3QXOe9om6ycY1dDgbbV1jy15ul5HHXmKQ8aHRYUSvkP6sSki
         8V6hjuYBtAQWQ==
Message-ID: <278dc8e098cf144b04b58f70f0a25fb106cd6d40.camel@kernel.org>
Subject: Re: [PATCH] ceph: add session already open notify support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 26 May 2022 10:20:16 -0400
In-Reply-To: <7b6cd1dd-4636-16be-0179-f90109b7a021@redhat.com>
References: <20220526060619.735109-1-xiubli@redhat.com>
         <79f391cfae8c84525c10fb795521e33c014b20bb.camel@kernel.org>
         <7b6cd1dd-4636-16be-0179-f90109b7a021@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-05-26 at 20:45 +0800, Xiubo Li wrote:
> On 5/26/22 6:44 PM, Jeff Layton wrote:
> > On Thu, 2022-05-26 at 14:06 +0800, Xiubo Li wrote:
> > > If the connection was accidently closed due to the socket issue or
> > > something else the clients will try to open the opened sessions, the
> > > MDSes will send the session open reply one more time if the clients
> > > support the notify feature.
> > >=20
> > > When the clients retry to open the sessions the s_seq will be 0 as
> > > default, we need to update it anyway.
> > >=20
> > > URL: https://tracker.ceph.com/issues/53911
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.c | 25 ++++++++++++++++++++-----
> > >   fs/ceph/mds_client.h |  5 ++++-
> > >   2 files changed, 24 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 4ced8d1e18ba..3e528b89b77a 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -3569,11 +3569,26 @@ static void handle_session(struct ceph_mds_se=
ssion *session,
> > >   	case CEPH_SESSION_OPEN:
> > >   		if (session->s_state =3D=3D CEPH_MDS_SESSION_RECONNECTING)
> > >   			pr_info("mds%d reconnect success\n", session->s_mds);
> > > -		session->s_state =3D CEPH_MDS_SESSION_OPEN;
> > > -		session->s_features =3D features;
> > > -		renewed_caps(mdsc, session, 0);
> > > -		if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &session->s_features))
> > > -			metric_schedule_delayed(&mdsc->metric);
> > > +
> > > +		if (session->s_state =3D=3D CEPH_MDS_SESSION_OPEN) {
> > > +			pr_info("mds%d already opened\n", session->s_mds);
> > Does the above pr_info actually help anything? What will the admin do
> > with this info? I'd probably just skip this since this is sort of
> > expected to happen from time to time.
>=20
> Currently from the MDS side code, it won't be allowed to send the=20
> session open reply more than once. So this should be something wrong=20
> somewhere just like this issue we are fixing. So it's should be okay,=20
> but maybe a warning instead ?
>=20

Ok. I'd probably go with pr_notice instead. It's not indicative of a
kernel bug, necessarily, and we don't really need the admin to take any
action (other than maybe report it to the ceph administrators).

>=20
> > > +		} else {
> > > +			session->s_state =3D CEPH_MDS_SESSION_OPEN;
> > > +			session->s_features =3D features;
> > > +			renewed_caps(mdsc, session, 0);
> > > +			if (test_bit(CEPHFS_FEATURE_METRIC_COLLECT,
> > > +				     &session->s_features))
> > > +				metric_schedule_delayed(&mdsc->metric);
> > > +		}
> > > +
> > > +		/*
> > > +		 * The connection maybe broken and the session in client
> > > +		 * side has been reinitialized, need to update the seq
> > > +		 * anyway.
> > > +		 */
> > > +		if (!session->s_seq && seq)
> > > +			session->s_seq =3D seq;
> > > +
> > >   		wake =3D 1;
> > >   		if (mdsc->stopping)
> > >   			__close_session(mdsc, session);
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index d8ec2ac93da3..256e3eada6c1 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -29,8 +29,10 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_MULTI_RECONNECT,
> > >   	CEPHFS_FEATURE_DELEG_INO,
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,
> > > +	CEPHFS_FEATURE_ALTERNATE_NAME,
> > > +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> > >  =20
> > > -	CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_METRIC_COLLECT,
> > > +	CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> > >   };
> > >  =20
> > >   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
> > > @@ -41,6 +43,7 @@ enum ceph_feature_type {
> > >   	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> > >   	CEPHFS_FEATURE_DELEG_INO,		\
> > >   	CEPHFS_FEATURE_METRIC_COLLECT,		\
> > > +	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
> > >   }
> > >  =20
> > >   /*
> > The rest looks OK though.
>=20

--=20
Jeff Layton <jlayton@kernel.org>
