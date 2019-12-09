Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCC5116F3A
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 15:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfLIOmZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 09:42:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27849 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbfLIOmZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 09:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575902543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/LYo6GGoc4EY4LHvvDmyRRCECT+0U2xUWHECYPZzk0U=;
        b=PxORKxBSmtWDhE14463j6MxJyTvsO/nWrgZ5JFKhgENBn6VvIGgaranvJ/MeNSVp2AhwPk
        ilBNrZTbACk0x0oxs5hXvWbfZQ4+eQwuQ5aFbslt2bACUbtimgUL/eWsmVrsR5Y260am3g
        3nQ8PL9h+Ly4Xnku2M2/L9YEwGfGdg0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-EMwZiKtFOCOs7gAGy3XWbg-1; Mon, 09 Dec 2019 09:42:20 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DDA08024D3;
        Mon,  9 Dec 2019 14:42:19 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CA425DA60;
        Mon,  9 Dec 2019 14:42:11 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH] ceph: retry the same mds later after the new session is
 opened
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20191209124715.2255-1-xiubli@redhat.com>
Message-ID: <bdabe434-df03-ab89-c668-6ee4b9521c7e@redhat.com>
Date:   Mon, 9 Dec 2019 22:42:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191209124715.2255-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: EMwZiKtFOCOs7gAGy3XWbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This can be seen almost every time when mounting:


 =C2=A092959 <7>[13220.815822] ceph: mount start 00000000e3b1070a
 =C2=A092960 <6>[13220.817349] libceph: mon2 (1)192.168.195.165:40566 sessi=
on=20
established
 =C2=A092961 <7>[13220.818639] ceph:=C2=A0 handle_map epoch 58 len 889
 =C2=A092962 <7>[13220.818644] ceph:=C2=A0 mdsmap_decode 1/3 4216 mds0.5=20
(1)192.168.195.165:6813 up:active=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D=3D> max_mds =3D=3D 3
 =C2=A092963 <7>[13220.818646] ceph:=C2=A0 mdsmap_decode 2/3 4339 mds1.55=
=20
(1)192.168.195.165:6815 up:active
 =C2=A092964 <7>[13220.818646] ceph:=C2=A0 mdsmap_decode 3/3 4340 mds2.57=
=20
(1)192.168.195.165:6814 up:active
 =C2=A092965 <7>[13220.818648] ceph:=C2=A0 mdsmap_decode m_enabled: 1, m_da=
maged:=20
0, m_num_laggy: 0
 =C2=A092966 <7>[13220.818648] ceph:=C2=A0 mdsmap_decode success epoch 58
 =C2=A092967 <7>[13220.818649] ceph:=C2=A0 check_new_map new 58 old 0
 =C2=A092968 <6>[13220.820577] libceph: client5819 fsid=20
6c39c42b-5888-4c6a-ba32-89acfa5a2353
 =C2=A092969 <7>[13220.821827] ceph:=C2=A0 mount opening path \t
 =C2=A092970 <7>[13220.821887] ceph:=C2=A0 open_root_inode opening ''
 =C2=A092971 <7>[13220.821892] ceph:=C2=A0 do_request on 000000005666e7bf
 =C2=A092972 <7>[13220.821893] ceph:=C2=A0 submit_request on 000000005666e7=
bf for=20
inode 0000000057da6992
 =C2=A092973 <7>[13220.821896] ceph:=C2=A0 __register_request 000000005666e=
7bf tid 1
 =C2=A092974 <7>[13220.821898] ceph:=C2=A0 __choose_mds 0000000057da6992 is=
_hash=3D0=20
(0) mode 0
 =C2=A092975 <7>[13220.821899] ceph:=C2=A0 choose_mds chose random=20
mds0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> random md=
s0
 =C2=A092976 <7>[13220.821901] ceph:=C2=A0 register_session: realloc to 1
 =C2=A092977 <7>[13220.821902] ceph:=C2=A0 register_session: mds0
 =C2=A092978 <7>[13220.821905] ceph:=C2=A0 mdsc get_session 000000001649fdb=
d 2 -> 3
 =C2=A092979 <7>[13220.821905] ceph:=C2=A0 mdsc con_get 000000001649fdbd ok=
 (3)
 =C2=A092980 <7>[13220.821910] ceph:=C2=A0 mdsc get_session 000000001649fdb=
d 3 -> 4
 =C2=A092981 <7>[13220.821912] ceph:=C2=A0 do_request mds0 session=20
000000001649fdbd state new
 =C2=A092982 <7>[13220.821913] ceph:=C2=A0 open_session to mds0 (up:active)
 =C2=A092983 [...]
 =C2=A092984 <7>[13220.822167] ceph:=C2=A0 do_request waiting
 =C2=A092985 [...]
 =C2=A092986 <7>[13220.833112] ceph:=C2=A0 handle_session mds0 open=20
000000001649fdbd state opening seq 0
 =C2=A092987 <7>[13220.833113] ceph:=C2=A0 renewed_caps mds0 ttl now 430794=
5924,=20
was fresh, now stale
 =C2=A092988 <7>[13220.833114] ceph:=C2=A0=C2=A0 wake request 000000005666e=
7bf tid 1
 =C2=A092989 <7>[13220.833116] ceph:=C2=A0 mdsc put_session 000000001649fdb=
d 4 -> 3
 =C2=A092990 <7>[13220.833117] ceph:=C2=A0 __choose_mds 0000000057da6992 is=
_hash=3D0=20
(0) mode 0
 =C2=A092991 <7>[13220.833118] ceph:=C2=A0 choose_mds chose random mds1=C2=
=A0=C2=A0=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> r=
andom mds1
 =C2=A092992 <7>[13220.833119] ceph:=C2=A0 register_session: realloc to 2
 =C2=A092993 <7>[13220.833121] ceph:=C2=A0 register_session: mds1
 =C2=A092994 <7>[13220.833122] ceph:=C2=A0 mdsc get_session 00000000534bd3e=
f 2 -> 3
 =C2=A092995 <7>[13220.833123] ceph:=C2=A0 mdsc con_get 00000000534bd3ef ok=
 (3)
 =C2=A092996 <7>[13220.833124] ceph:=C2=A0 mdsc get_session 00000000534bd3e=
f 3 -> 4
 =C2=A092997 <7>[13220.833124] ceph:=C2=A0 do_request mds1 session=20
00000000534bd3ef state new
 =C2=A092998 <7>[13220.833126] ceph:=C2=A0 open_session to mds1 (up:active)
 =C2=A092999 [...]
 =C2=A093000 <7>[13220.845883] ceph:=C2=A0 handle_session mds1 open=20
00000000534bd3ef state opening seq 0
 =C2=A093001 <7>[13220.845884] ceph:=C2=A0 renewed_caps mds1 ttl now 430794=
5935,=20
was fresh, now stale
 =C2=A093002 <7>[13220.845885] ceph:=C2=A0=C2=A0 wake request 000000005666e=
7bf tid 1
 =C2=A093003 <7>[13220.845887] ceph:=C2=A0 mdsc put_session 00000000534bd3e=
f 4 -> 3
 =C2=A093004 <7>[13220.845888] ceph:=C2=A0 __choose_mds 0000000057da6992 is=
_hash=3D0=20
(0) mode 0
 =C2=A093005 <7>[13220.845889] ceph:=C2=A0 choose_mds chose random mds2=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> random mds2
 =C2=A093006 <7>[13220.845890] ceph:=C2=A0 register_session: realloc to 4
 =C2=A093007 <7>[13220.845891] ceph:=C2=A0 register_session: mds2
 =C2=A093008 <7>[13220.845892] ceph:=C2=A0 mdsc get_session 0000000076259af=
8 2 -> 3
 =C2=A093009 <7>[13220.845892] ceph:=C2=A0 mdsc con_get 0000000076259af8 ok=
 (3)
 =C2=A093010 <7>[13220.845893] ceph:=C2=A0 mdsc get_session 0000000076259af=
8 3 -> 4
 =C2=A093011 <7>[13220.845893] ceph:=C2=A0 do_request mds2 session=20
0000000076259af8 state new
 =C2=A093012 <7>[13220.845894] ceph:=C2=A0 open_session to mds2 (up:active)
 =C2=A0 [...]
 =C2=A093014 <7>[13220.852986] ceph:=C2=A0 handle_session mds2 open=20
0000000076259af8 state opening seq 0
 =C2=A093015 <7>[13220.852987] ceph:=C2=A0 renewed_caps mds2 ttl now 430794=
5948,=20
was fresh, now stale
 =C2=A093016 <7>[13220.852988] ceph:=C2=A0=C2=A0 wake request 000000005666e=
7bf tid 1
 =C2=A093017 <7>[13220.852990] ceph:=C2=A0 mdsc put_session 0000000076259af=
8 4 -> 3
 =C2=A093018 <7>[13220.852991] ceph:=C2=A0 __choose_mds 0000000057da6992 is=
_hash=3D0=20
(0) mode 0
 =C2=A093019 <7>[13220.852992] ceph:=C2=A0 choose_mds chose random mds0=20
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D> choose random mds0 again
 =C2=A093020 <7>[13220.852993] ceph:=C2=A0 mdsc get_session 0000000076259af=
8 3 -> 4
 =C2=A093021 <7>[13220.852994] ceph:=C2=A0 mdsc get_session 0000000076259af=
8 4 -> 5
 =C2=A093022 <7>[13220.852994] ceph:=C2=A0 do_request mds0 session=20
0000000076259af8 state open
 =C2=A093023 <7>[13220.852996] ceph:=C2=A0 prepare_send_request 00000000566=
6e7bf=20
tid 1 getattr (attempt 1)
 =C2=A093024 <7>[13220.852997] ceph:=C2=A0=C2=A0 path
 =C2=A093025 <7>[13220.852998] ceph: r_parent =3D 0000000057da6992
 =C2=A093026 [...]
 =C2=A093027 <7>[13220.853414] ceph:=C2=A0 handle_reply 000000005666e7bf
 =C2=A093028 <7>[13220.853415] ceph:=C2=A0 __unregister_request 00000000566=
6e7bf tid 1
 =C2=A093029 <7>[13220.853416] ceph:=C2=A0 got safe reply 1, mds0, last req=
uest: Yes
 =C2=A093030 <7>[13220.853417] ceph:=C2=A0 handle_reply tid 1 result 0
 =C2=A093031 <7>[13220.853421] ceph:=C2=A0 fill_trace 000000005666e7bf is_d=
entry 0=20
is_target 1
 =C2=A093032 <7>[13220.853424] ceph:=C2=A0 alloc_inode 00000000a823bfed
 =C2=A093033 <7>[13220.853427] ceph:=C2=A0 get_inode created new inode=20
00000000a823bfed 1.fffffffffffffffe ino 1
 =C2=A093034 <7>[13220.853428] ceph:=C2=A0 get_inode on 1=3D1.fffffffffffff=
ffe got=20
00000000a823bfed
 =C2=A093035 <7>[13220.853429] ceph:=C2=A0 fill_inode 00000000a823bfed ino=
=20
1.fffffffffffffffe v 81286 had 0
 =C2=A093036 <7>[13220.853431] ceph:=C2=A0 00000000a823bfed mode 040755 uid=
.gid 0.0
 =C2=A093037 <7>[13220.853433] ceph:=C2=A0 truncate_size 0 -> 1844674407370=
9551615
 =C2=A093038 <7>[13220.853435] ceph:=C2=A0 fill_trace done err=3D0
 =C2=A093039 <7>[13220.853441] ceph:=C2=A0 mdsc con_put 0000000076259af8 (4=
)
 =C2=A093040 <7>[13220.853442] ceph:=C2=A0 mdsc put_session 0000000076259af=
8 5 -> 4
 =C2=A093041 <7>[13220.853446] ceph:=C2=A0 do_request waited, got 0
 =C2=A093042 <7>[13220.853447] ceph:=C2=A0 do_request 000000005666e7bf done=
, result 0
 =C2=A093043 <7>[13220.853447] ceph:=C2=A0 open_root_inode success
 =C2=A093044 <7>[13220.853452] ceph:=C2=A0 open_root_inode success, root de=
ntry is=20
0000000037517481
[...]
 =C2=A093050 <7>[13220.853457] ceph:=C2=A0 mount success


On 2019/12/9 20:47, xiubli@redhat.com wrote:
> From: Xiubo Li<xiubli@redhat.com>
>
> With max_mds > 1 and for a request which are choosing a random
> mds rank and if the relating session is not opened yet, the request
> will wait the session been opened and resend again. While every
> time the request is beening __do_request, it will release the
> req->session first and choose a random one again, so this time it
> may choose another random mds rank. The worst case is that it will
> open all the mds sessions one by one just before it can be
> successfully sent out out.
>
> Signed-off-by: Xiubo Li<xiubli@redhat.com>
> ---
>   fs/ceph/mds_client.c | 20 ++++++++++++++++----
>   1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 68f3b5ed6ac8..d747e9baf9c9 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -876,7 +876,8 @@ static struct inode *get_nonsnap_parent(struct dentry=
 *dentry)
>    * Called under mdsc->mutex.
>    */
>   static int __choose_mds(struct ceph_mds_client *mdsc,
> -=09=09=09struct ceph_mds_request *req)
> +=09=09=09struct ceph_mds_request *req,
> +=09=09=09bool *random)
>   {
>   =09struct inode *inode;
>   =09struct ceph_inode_info *ci;
> @@ -886,6 +887,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>   =09u32 hash =3D req->r_direct_hash;
>   =09bool is_hash =3D test_bit(CEPH_MDS_R_DIRECT_IS_HASH, &req->r_req_fla=
gs);
>  =20
> +=09if (random)
> +=09=09*random =3D false;
> +
>   =09/*
>   =09 * is there a specific mds we should try?  ignore hint if we have
>   =09 * no session and the mds is not up (active or recovering).
> @@ -1021,6 +1025,9 @@ static int __choose_mds(struct ceph_mds_client *mds=
c,
>   =09return mds;
>  =20
>   random:
> +=09if (random)
> +=09=09*random =3D true;
> +
>   =09mds =3D ceph_mdsmap_get_random_mds(mdsc->mdsmap);
>   =09dout("choose_mds chose random mds%d\n", mds);
>   =09return mds;
> @@ -2556,6 +2563,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
>   =09struct ceph_mds_session *session =3D NULL;
>   =09int mds =3D -1;
>   =09int err =3D 0;
> +=09bool random;
>  =20
>   =09if (req->r_err || test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)=
) {
>   =09=09if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
> @@ -2596,7 +2604,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
>  =20
>   =09put_request_session(req);
>  =20
> -=09mds =3D __choose_mds(mdsc, req);
> +=09mds =3D __choose_mds(mdsc, req, &random);
>   =09if (mds < 0 ||
>   =09    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE=
) {
>   =09=09dout("do_request no mds or not active, waiting for map\n");
> @@ -2624,8 +2632,12 @@ static void __do_request(struct ceph_mds_client *m=
dsc,
>   =09=09=09goto out_session;
>   =09=09}
>   =09=09if (session->s_state =3D=3D CEPH_MDS_SESSION_NEW ||
> -=09=09    session->s_state =3D=3D CEPH_MDS_SESSION_CLOSING)
> +=09=09    session->s_state =3D=3D CEPH_MDS_SESSION_CLOSING) {
>   =09=09=09__open_session(mdsc, session);
> +=09=09=09/* retry the same mds later */
> +=09=09=09if (random)
> +=09=09=09=09req->r_resend_mds =3D mds;
> +=09=09}
>   =09=09list_add(&req->r_wait, &session->s_waiting);
>   =09=09goto out_session;
>   =09}
> @@ -2890,7 +2902,7 @@ static void handle_reply(struct ceph_mds_session *s=
ession, struct ceph_msg *msg)
>   =09=09=09mutex_unlock(&mdsc->mutex);
>   =09=09=09goto out;
>   =09=09} else  {
> -=09=09=09int mds =3D __choose_mds(mdsc, req);
> +=09=09=09int mds =3D __choose_mds(mdsc, req, NULL);
>   =09=09=09if (mds >=3D 0 && mds !=3D req->r_session->s_mds) {
>   =09=09=09=09dout("but auth changed, so resending\n");
>   =09=09=09=09__do_request(mdsc, req);


